//
//  
//  MainTabBarExternalDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import UIKit

protocol MainTabBarExternalDependenciesResolver {
    
    func mainTabBarCoordinator() -> Coordinator
    func charactersCoordinator() -> Coordinator
    func locationsCoordinator() -> Coordinator
    func episodesCoordinator() -> Coordinator
    func charactersNavigationController() -> UINavigationController
    func locationsNavigationController() -> UINavigationController
    func episodesNavigationController() -> UINavigationController
    func resolve() -> UIWindow
    
}

extension MainTabBarExternalDependenciesResolver {
    func mainTabBarCoordinator() -> Coordinator {
        MainTabBarCoordinatorImpl(dependencies: self)
    }
}
