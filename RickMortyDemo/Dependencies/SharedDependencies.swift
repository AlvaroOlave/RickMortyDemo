//
//  SharedDependencies.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 18/10/24.
//

import Foundation
import UIKit

final class SharedDependencies {
    
    private let window: UIWindow
    
    private let charactersNavController = UINavigationController()
    private let locationsNavController = UINavigationController()
    private let episodesNavController = UINavigationController()
    
    var rootCoordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func resolve() -> UIWindow {
        window
    }
    
    func charactersNavigationController() -> UINavigationController {
        charactersNavController
    }
    
    func locationsNavigationController() -> UINavigationController {
        locationsNavController
    }
    
    func episodesNavigationController() -> UINavigationController {
        episodesNavController
    }
}

extension SharedDependencies:
    MainTabBarExternalDependenciesResolver,
    CharactersExternalDependenciesResolver,
    LocationsExternalDependenciesResolver,
    EpisodesExternalDependenciesResolver,
    CharacterDetailExternalDependenciesResolver,
    LocationDetailExternalDependenciesResolver{}
