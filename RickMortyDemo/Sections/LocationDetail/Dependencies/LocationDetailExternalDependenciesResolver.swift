//
//  
//  LocationDetailExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation
import UIKit

protocol LocationDetailExternalDependenciesResolver {
    
    func locationDetailCoordinator() -> BindableCoordinator
    func characterDetailCoordinator() -> BindableCoordinator
}

extension LocationDetailExternalDependenciesResolver {
    func locationDetailCoordinator() -> BindableCoordinator {
        LocationDetailCoordinatorImpl(dependencies: self)
    }
}
