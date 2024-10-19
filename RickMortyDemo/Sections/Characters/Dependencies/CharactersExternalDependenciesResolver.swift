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
    func charactersNavigationController() -> UINavigationController
}

extension CharactersExternalDependenciesResolver {
    func charactersCoordinator() -> Coordinator {
        CharactersCoordinatorImpl(dependencies: self,
                                  navigationController: charactersNavigationController())
    }
}
