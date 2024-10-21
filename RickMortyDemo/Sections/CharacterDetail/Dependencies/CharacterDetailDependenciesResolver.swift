//
//  
//  CharacterDetailDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation

protocol CharacterDetailDependenciesResolver {
    var external: CharacterDetailExternalDependenciesResolver { get }
    func resolve() -> CharacterDetailViewController
    func resolve() -> CharacterDetailViewModel
    func resolve() -> CharacterDetailCoordinator?
    func resolve() -> CharacterUseCase
    func resolve() -> EpisodeUseCase
}

extension CharacterDetailDependenciesResolver {
    func resolve() -> CharacterDetailViewController {
        CharacterDetailViewController(dependencies: self)
    }
    
    func resolve() -> CharacterDetailViewModel {
        CharacterDetailViewModel(dependencies: self)
    }
    
    func resolve() -> CharacterUseCase {
        CharacterUseCaseImpl(repository: CharacterRepositoryImpl(baseURL: Config.baseURL))
    }
    
    func resolve() -> EpisodeUseCase {
        EpisodeUseCaseImpl(repository: EpisodeRepositoryImpl(baseURL: Config.baseURL))
    }
}
