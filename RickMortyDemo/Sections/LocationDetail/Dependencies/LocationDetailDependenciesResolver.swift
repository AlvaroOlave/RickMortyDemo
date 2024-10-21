//
//  
//  LocationDetailDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation

protocol LocationDetailDependenciesResolver {
    var external: LocationDetailExternalDependenciesResolver { get }
    func resolve() -> LocationDetailViewController
    func resolve() -> LocationDetailViewModel
    func resolve() -> LocationDetailCoordinator?
    func resolve() -> LocationUseCase
}

extension LocationDetailDependenciesResolver {
    func resolve() -> LocationDetailViewController {
        LocationDetailViewController(dependencies: self)
    }
    
    func resolve() -> LocationDetailViewModel {
        LocationDetailViewModel(dependencies: self)
    }
    
    func resolve() -> LocationUseCase {
        LocationUseCaseImpl(repository: LocationRepositoryImpl(baseURL: Config.baseURL))
    }
}
