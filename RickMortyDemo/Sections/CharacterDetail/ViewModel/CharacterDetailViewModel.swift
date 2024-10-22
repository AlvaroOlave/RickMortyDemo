//
//  
//  CharacterDetailViewModel.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation
import Combine

enum CharacterDetailState {
    case idle
    case showCharacter(Character)
    case showEpisode(Episode)
    case showLoading(Bool)
    case showError(Error)
}

final class CharacterDetailViewModel {

    private let dependencies: CharacterDetailDependenciesResolver
    
    private var coordinator: CharacterDetailCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var characterUseCase: CharacterUseCase = {
        dependencies.resolve()
    }()
    
    private lazy var episodeUseCase: EpisodeUseCase = {
        dependencies.resolve()
    }()
    
    @Published var state: CharacterDetailState = .idle
    
    init(dependencies: CharacterDetailDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        if let character: Character = coordinator?.dataBinding.get() {
            state = .showCharacter(character)
        } else if let id: Int = coordinator?.dataBinding.get() {
            loadCharacter(id)
        }
    }
    
    func goToLocation(_ id: Int) {
        coordinator?.goToLocation(id)
    }
    
    func goToCharacter(_ id: Int) {
        coordinator?.goToCharacter(id)
    }
    
    func loadEpisode(_ id: Int) {
        state = .showLoading(true)
        Task {
            do {
                let dto = try await episodeUseCase.getEpisode(id: id)
                state = .showEpisode(Episode(with: dto))
                state = .showLoading(false)
            } catch {
                state = .showError(error)
                state = .showLoading(false)
            }
        }
    }
}

private extension CharacterDetailViewModel {
    func loadCharacter(_ id: Int) {
        state = .showLoading(true)
        Task {
            do {
                let dto = try await characterUseCase.getCharacter(id: id)
                state = .showCharacter(Character(with: dto))
                state = .showLoading(false)
            } catch {
                state = .showError(error)
                state = .showLoading(false)
            }
        }
    }
}
