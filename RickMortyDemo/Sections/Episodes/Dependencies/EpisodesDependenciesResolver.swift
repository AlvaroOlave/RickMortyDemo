//
//  
//  EpisodesDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation

protocol EpisodesDependenciesResolver {
    var external: EpisodesExternalDependenciesResolver { get }
    func resolve() -> EpisodesViewController
    func resolve() -> EpisodesViewModel
    func resolve() -> EpisodesCoordinator?
    func resolve() -> EpisodesUseCase
}

extension EpisodesDependenciesResolver {
    func resolve() -> EpisodesViewController {
        EpisodesViewController(dependencies: self)
    }
    
    func resolve() -> EpisodesViewModel {
        EpisodesViewModel(dependencies: self)
    }
    
    func resolve() -> EpisodesUseCase {
        EpisodesUseCaseImpl(repository: EpisodesRepositoryImpl(baseURL: Config.baseURL))
    }
}
