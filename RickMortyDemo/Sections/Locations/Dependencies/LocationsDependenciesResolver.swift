//
//  
//  LocationsDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation

protocol LocationsDependenciesResolver {
    var external: LocationsExternalDependenciesResolver { get }
    func resolve() -> LocationsViewController
    func resolve() -> LocationsViewModel
    func resolve() -> LocationsCoordinator?
    func resolve() -> LocationsUseCase
}

extension LocationsDependenciesResolver {
    func resolve() -> LocationsViewController {
        LocationsViewController(dependencies: self)
    }
    
    func resolve() -> LocationsViewModel {
        LocationsViewModel(dependencies: self)
    }
    
    func resolve() -> LocationsUseCase {
        LocationsUseCaseImpl(repository: LocationRepositoryImpl(baseURL: Config.baseURL))
    }
}
