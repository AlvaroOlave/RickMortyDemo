//
//  UseCasesMocks.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import Foundation
@testable import RickMortyDemo

class MockEpisodesUseCase: EpisodesUseCase {
    
    var shouldThrowError = false
    var mockEpisodes: [Episode] = []
    var isCalled = false
    
    func getEpisodes() async throws -> [Episode] {
        isCalled = true
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockEpisodes
    }
}

class MockCharactersUseCase: CharactersUseCase {
    var shouldThrowError = false
    var mockCharacters: [Character] = []
    var isCalled = false
    
    func getCharacters() async throws -> [Character] {
        isCalled = true
        if shouldThrowError {
            throw NSError(domain: "",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockCharacters
    }
}

class MockCharacterUseCase: CharacterUseCase {
    var shouldThrowError = false
    var mockCharacter: Character = Character.mockCharacter(id: 0)
    var isCalled = false
    
    func getCharacter(id: Int) async throws -> RickMortyDemo.Character {
        isCalled = true
        if shouldThrowError {
            throw NSError(domain: "",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockCharacter
    }
}

class MockLocationUseCase: LocationUseCase {
    var shouldThrowError = false
    var mockLocation: Location = Location.mockLocation(id: 0)
    
    func getLocation(id: Int) async throws -> Location {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockLocation
    }
}

class MockEpisodeUseCase: EpisodeUseCase {
    var shouldThrowError = false
    var mockedEpisode: Episode?
    
    func getEpisode(id: Int) async throws -> Episode {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockedEpisode ?? Episode.mockEpisode()
    }
}

extension Character {
    static func mockCharacter(id: Int) -> Character {
        Character(id: id,
                  name: "name",
                  status: .Alive,
                  species: "species",
                  type: "type",
                  gender: .Female,
                  origin: CharacterOrigin(name: "",
                                          url: ""),
                  location: CharacterLocation(name: "",
                                              url: ""),
                  image: "",
                  episode: [],
                  url: "",
                  created: "")
    }
}

extension Episode {
    static func mockEpisode(id: Int = 0) -> Episode {
        Episode(id: id,
                name: "name",
                air_date: "date",
                episode: "episode",
                characters: [],
                url: "",
                created: "")
    }
}

extension Location {
    static func mockLocation(id: Int) -> Location {
        Location(id: id,
                 name: "",
                 type: "",
                 dimension: "",
                 residents: [],
                 url: "",
                 created: "")
    }
}
