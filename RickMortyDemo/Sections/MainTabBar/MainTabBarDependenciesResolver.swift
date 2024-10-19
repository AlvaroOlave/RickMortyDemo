//
//  
//  MainTabBarDependenciesResolver.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation

protocol MainTabBarDependenciesResolver {
    var external: MainTabBarExternalDependenciesResolver { get }

    func resolve() -> MainTabBarCoordinator?
    func resolve() -> MainTabBarController
}

extension MainTabBarDependenciesResolver {
    func resolve() -> MainTabBarController {
        MainTabBarController(dependencies: self)
    }
}
