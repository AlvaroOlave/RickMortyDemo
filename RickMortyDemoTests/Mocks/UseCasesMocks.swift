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
    var mockEpisodes: [EpisodeDTO] = []
    var isCalled = false
    
    func getEpisodes() async throws -> [EpisodeDTO] {
        isCalled = true
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockEpisodes
    }
}

class MockCharactersUseCase: CharactersUseCase {
    var shouldThrowError = false
    var mockCharacters: [CharacterDTO] = []
    var isCalled = false
    
    func getCharacters() async throws -> [CharacterDTO] {
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
    var mockCharacter: CharacterDTO = CharacterDTO.mockCharacter(id: 0)
    var isCalled = false
    
    func getCharacter(id: Int) async throws -> CharacterDTO {
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
    var mockLocation: LocationDTO = LocationDTO.mockLocation(id: 0)
    
    func getLocation(id: Int) async throws -> LocationDTO {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockLocation
    }
}

class MockEpisodeUseCase: EpisodeUseCase {
    var shouldThrowError = false
    var mockedEpisode: EpisodeDTO?
    
    func getEpisode(id: Int) async throws -> EpisodeDTO {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockedEpisode ?? EpisodeDTO.mockEpisode()
    }
}

extension CharacterDTO {
    static func mockCharacter(id: Int) -> CharacterDTO {
        CharacterDTO(id: id,
                     name: "name",
                     status: "Alive",
                     species: "species",
                     type: "type",
                     gender: "Female",
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

extension EpisodeDTO {
    static func mockEpisode(id: Int = 0) -> EpisodeDTO {
        EpisodeDTO(id: id,
                   name: "name",
                   air_date: "date",
                   episode: "episode",
                   characters: [],
                   url: "",
                   created: "")
    }
}

extension LocationDTO {
    static func mockLocation(id: Int) -> LocationDTO {
        LocationDTO(id: id,
                    name: "",
                    type: "",
                    dimension: "",
                    residents: [],
                    url: "",
                    created: "")
    }
}
