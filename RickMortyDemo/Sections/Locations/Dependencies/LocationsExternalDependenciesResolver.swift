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
    func locationsNavigationController() -> UINavigationController
}

extension LocationsExternalDependenciesResolver {
    func locationsCoordinator() -> Coordinator {
        LocationsCoordinatorImpl(dependencies: self,
                                 navigationController: locationsNavigationController())
    }
}
