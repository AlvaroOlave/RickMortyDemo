//
//  
//  EpisodesViewModel.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import Combine

enum EpisodesState {
    case idle
    case addEpisodes([Episode])
    case showLoading(Bool)
    case showError(Error)
}

final class EpisodesViewModel {

    private let dependencies: EpisodesDependenciesResolver
    
    private var coordinator: EpisodesCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var episodesUseCase: EpisodesUseCase = {
        dependencies.resolve()
    }()
    
    internal var isLoading = false
    internal var hasMore = true
    @Published var state: EpisodesState = .idle
    
    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        state = .showLoading(true)
        loadEpisodes()
    }
    
    func loadMoreEpisodes() {
        guard !isLoading, hasMore else { return }
        loadEpisodes()
    }
    
    func goToCharacter(_ id: Int) {
        coordinator?.goToCharacter(id)
    }
}

private extension EpisodesViewModel {
    func loadEpisodes() {
        Task {
            isLoading = true
            do {
                let dtos = try await episodesUseCase.getEpisodes()
                hasMore = !dtos.isEmpty
                state = .addEpisodes(dtos.map({ Episode(with: $0) }))
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
