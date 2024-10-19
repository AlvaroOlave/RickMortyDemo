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
    case addCharacters([Character])
    case showLoading(Bool)
    case showError(Error)
}

final class CharactersViewModel {

    private let dependencies: CharactersDependenciesResolver
    
    private var coordinator: CharactersCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var charactersUseCase: CharactersUseCase = {
        dependencies.resolve()
    }()
    
    private var isLoading = false
    
    @Published var state: CharactersState = .idle
    
    init(dependencies: CharactersDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        state = .showLoading(true)
        loadCharacters()
    }
    
    func loadMoreCharacters() {
        guard !isLoading else { return }
        loadCharacters()
    }
}

private extension CharactersViewModel {
    func loadCharacters() {
        Task {
            isLoading = true
            do {
                let characters = try await charactersUseCase.getCharacters()
                state = .addCharacters(characters)
                state = .showLoading(false)
                isLoading = false
            } catch {
                state = .showError(error)
                state = .showLoading(false)
                isLoading = false
            }
        }
    }
}
