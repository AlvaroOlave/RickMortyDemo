//
//  
//  CharactersDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation

protocol CharactersDependenciesResolver {
    var external: CharactersExternalDependenciesResolver { get }
    func resolve() -> CharactersViewController
    func resolve() -> CharactersViewModel
    func resolve() -> CharactersCoordinator?
    func resolve() -> CharactersUseCase
    func resolve() -> FilterCharactersUseCase
}

extension CharactersDependenciesResolver {
    func resolve() -> CharactersViewController {
        CharactersViewController(dependencies: self)
    }
    
    func resolve() -> CharactersViewModel {
        CharactersViewModel(dependencies: self)
    }
    
    func resolve() -> CharactersUseCase {
        CharactersUseCaseImpl(repository: CharactersRepositoryImpl(baseURL: Config.baseURL))
    }
    
    func resolve() -> FilterCharactersUseCase {
        FilterCharactersUseCaseImpl(repository: FilterCharactersRepositoryImpl(baseURL: Config.baseURL))
    }
}
