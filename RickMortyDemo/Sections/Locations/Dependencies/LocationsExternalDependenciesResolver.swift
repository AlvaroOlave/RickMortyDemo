//
//  
//  LocationsExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import UIKit

protocol LocationsExternalDependenciesResolver {
    
    func locationsCoordinator() -> Coordinator
    func locationDetailCoordinator() -> BindableCoordinator
    func locationsNavigationController() -> UINavigationController
    
    func resolve() -> LocationUseCase
    func resolve() -> CharacterUseCase
}

extension LocationsExternalDependenciesResolver {
    func locationsCoordinator() -> Coordinator {
        LocationsCoordinatorImpl(dependencies: self,
                                 navigationController: locationsNavigationController())
    }
    
    func resolve() -> LocationUseCase {
        LocationUseCaseImpl(repository: LocationRepositoryImpl(baseURL: Config.baseURL))
    }
}
