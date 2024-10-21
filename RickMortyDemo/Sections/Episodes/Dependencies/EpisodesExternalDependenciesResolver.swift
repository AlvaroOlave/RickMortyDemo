//
//  
//  EpisodesExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import UIKit

protocol EpisodesExternalDependenciesResolver {
    
    func episodesCoordinator() -> Coordinator
    func characterDetailCoordinator() -> BindableCoordinator
    func episodesNavigationController() -> UINavigationController
    
    func resolve() -> EpisodeUseCase
    func resolve() -> CharacterUseCase
}

extension EpisodesExternalDependenciesResolver {
    func episodesCoordinator() -> Coordinator {
        EpisodesCoordinatorImpl(dependencies: self,
                                navigationController: episodesNavigationController())
    }
    
    func resolve() -> EpisodeUseCase {
        EpisodeUseCaseImpl(repository: EpisodeRepositoryImpl(baseURL: Config.baseURL))
    }
}
