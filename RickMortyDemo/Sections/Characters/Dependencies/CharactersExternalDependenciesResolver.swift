//
//  
//  CharactersExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import UIKit

protocol CharactersExternalDependenciesResolver {
    
    func charactersCoordinator() -> Coordinator
    func characterDetailCoordinator() -> BindableCoordinator
    func charactersNavigationController() -> UINavigationController
    
    func resolve() -> CharacterUseCase
    func resolve() -> LocationUseCase
}

extension CharactersExternalDependenciesResolver {
    func charactersCoordinator() -> Coordinator {
        CharactersCoordinatorImpl(dependencies: self,
                                  navigationController: charactersNavigationController())
    }
    
    func resolve() -> CharacterUseCase {
        CharacterUseCaseImpl(repository: CharacterRepositoryImpl(baseURL: Config.baseURL))
    }
}
