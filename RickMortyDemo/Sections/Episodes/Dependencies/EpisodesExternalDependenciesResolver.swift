//
//  
//  EpisodesExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import UIKit

protocol EpisodesExternalDependenciesResolver {
    
    func episodesCoordinator() -> Coordinator
    func episodesNavigationController() -> UINavigationController
}

extension EpisodesExternalDependenciesResolver {
    func episodesCoordinator() -> Coordinator {
        EpisodesCoordinatorImpl(dependencies: self,
                                navigationController: episodesNavigationController())
    }
}
