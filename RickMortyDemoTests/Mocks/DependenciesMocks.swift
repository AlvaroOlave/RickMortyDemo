//
//  DependenciesMocks.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import UIKit
@testable import RickMortyDemo

class MockCharactersDependencies: CharactersDependenciesResolver {
    
    let external: CharactersExternalDependenciesResolver = MockCharactersExternalDependencies()
    let mockUseCase = MockCharactersUseCase()
    let mockCoordinator = MockCharactersCoordinator()
    
    func resolve() -> CharactersUseCase {
        mockUseCase
    }
    
    func resolve() -> CharactersCoordinator? {
        mockCoordinator
    }
}

class MockCharactersExternalDependencies: CharactersExternalDependenciesResolver {
    let mockUseCase = MockCharactersUseCase()
    let mockCoordinator = MockCharactersCoordinator()
    
    func resolve() -> CharactersUseCase {
        mockUseCase
    }
    
    func resolve() -> CharactersCoordinator? {
        mockCoordinator
    }
    
    func resolve() -> LocationUseCase {
        MockLocationUseCase()
    }
    
    func characterDetailCoordinator() -> BindableCoordinator {
        MockBindableCoordinator()
    }
    
    func charactersNavigationController() -> UINavigationController {
        UINavigationController()
    }
}

class MockEpisodeDependencies: EpisodesDependenciesResolver {
    let external: EpisodesExternalDependenciesResolver = MockEpisodesExternalDependenciesResolver()
    let mockUseCase = MockEpisodesUseCase()
    let mockCoordinator = MockEpisodesCoordinator()
    
    func resolve() -> EpisodesUseCase {
        return mockUseCase
    }
    
    func resolve() -> EpisodesCoordinator? {
        return mockCoordinator
    }
}

class MockEpisodesExternalDependenciesResolver: EpisodesExternalDependenciesResolver {
    func resolve() -> CharacterUseCase {
        MockCharacterUseCase()
    }
    
    func characterDetailCoordinator() -> BindableCoordinator {
        MockBindableCoordinator()
    }
    
    func episodesNavigationController() -> UINavigationController {
        UINavigationController()
    }
}

class MockLocationDependencies: LocationDetailDependenciesResolver {
    let external: LocationDetailExternalDependenciesResolver = MockLocationDetailExternalDependenciesResolver()
    let mockUseCase = MockLocationUseCase()
    let mockCoordinator = MockLocationDetailCoordinator()
    
    func resolve() -> LocationUseCase {
        return mockUseCase
    }
    
    func resolve() -> LocationDetailCoordinator? {
        return mockCoordinator
    }
}

class MockLocationDetailExternalDependenciesResolver: LocationDetailExternalDependenciesResolver {
    func characterDetailCoordinator() -> BindableCoordinator {
        MockBindableCoordinator()
    }
}

class MockCharacterDetailDependenciesResolver: CharacterDetailDependenciesResolver {
    var external: CharacterDetailExternalDependenciesResolver = MockCharacterDetailExternalDependenciesResolver()
    let mockCharacterUseCase = MockCharacterUseCase()
    let mockEpisodeUseCase = MockEpisodeUseCase()
    let mockCoordinator = MockCharacterDetailCoordinator()
    
    func resolve() -> CharacterDetailCoordinator? {
        mockCoordinator
    }
    
    func resolve() -> EpisodeUseCase {
        mockEpisodeUseCase
    }
}

class MockCharacterDetailExternalDependenciesResolver: CharacterDetailExternalDependenciesResolver {
    func locationDetailCoordinator() -> BindableCoordinator {
        MockBindableCoordinator()
    }
}
