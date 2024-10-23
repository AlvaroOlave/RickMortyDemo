//
//  
//  CharactersViewModel.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import Combine

enum CharactersState {
    case idle
    case addCharacters([[Character]])
    case showLoading(Bool)
    case showError(Error)
    case reset
}

final class CharactersViewModel {

    private let dependencies: CharactersDependenciesResolver
    
    private var coordinator: CharactersCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var charactersUseCase: CharactersUseCase = {
        dependencies.resolve()
    }()
    
    private lazy var filterCharactersUseCase: FilterCharactersUseCase = {
        dependencies.resolve()
    }()
    
    internal var isLoading = false
    internal var hasMore = true
    internal var currentFilter: String?
    
    @Published var state: CharactersState = .idle
    
    init(dependencies: CharactersDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        state = .showLoading(true)
        load()
    }
    
    func loadMoreCharacters() {
        guard !isLoading && hasMore else { return }
        load()
    }
    
    func goToDetail(_ character: Character) {
        coordinator?.goToDetail(character)
    }
    
    func filterByStatus(_ status: Status?) {
        reset()
        currentFilter = status?.toQueryParams()
        load()
    }
}

private extension CharactersViewModel {
    func load() {
        if let currentFilter = currentFilter {
            filterCharacters(params: [currentFilter])
        } else {
            loadCharacters()
        }
    }
    
    func loadCharacters() {
        Task {
            isLoading = true
            do {
                let characters = try await charactersUseCase.getCharacters()
                hasMore = !characters.isEmpty
                splitCharacters(characters.map({ Character(with: $0) }))
                state = .showLoading(false)
                isLoading = false
            } catch {
                state = .showError(error)
                state = .showLoading(false)
                isLoading = false
            }
        }
    }
    
    func filterCharacters(params: [String]) {
        Task {
            isLoading = true
            do {
                let characters = try await filterCharactersUseCase.getCharacter(params: params)
                hasMore = !characters.isEmpty
                splitCharacters(characters.map({ Character(with: $0) }))
                state = .showLoading(false)
                isLoading = false
            } catch {
                state = .showError(error)
                state = .showLoading(false)
                isLoading = false
            }
        }
    }
    
    func splitCharacters(_ characters: [Character]) {
        var grouped = [[Character]]()
        var pairBuffer = [Character]()
        
        characters.forEach { character in
            if character.name.range(of: "Rick", options: .caseInsensitive) != nil || 
                character.name.range(of: "Morty", options: .caseInsensitive) != nil {
                grouped.append([character])
            } else {
                pairBuffer.append(character)
                if pairBuffer.count == 2 {
                    grouped.append(pairBuffer)
                    pairBuffer.removeAll()
                }
            }
        }
        if !pairBuffer.isEmpty {
            grouped.append(pairBuffer)
        }
        state = .addCharacters(grouped)
    }
    
    func reset() {
        state = .reset
        charactersUseCase.reset()
        filterCharactersUseCase.reset()
        isLoading = false
        hasMore = true
    }
}
