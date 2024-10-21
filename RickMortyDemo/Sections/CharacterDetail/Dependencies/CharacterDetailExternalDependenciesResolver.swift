//
//  
//  CharacterDetailExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation
import UIKit

protocol CharacterDetailExternalDependenciesResolver {
    
    func characterDetailCoordinator() -> BindableCoordinator
    func locationDetailCoordinator() -> BindableCoordinator
}

extension CharacterDetailExternalDependenciesResolver {
    func characterDetailCoordinator() -> BindableCoordinator {
        CharacterDetailCoordinatorImpl(dependencies: self)
    }
}
