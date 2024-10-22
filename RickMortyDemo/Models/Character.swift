//
//  Character.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    
    init(with dto: CharacterDTO) {
        self.id = dto.id
        self.name = dto.name
        self.status = Status(rawValue: dto.status) ?? .unknown
        self.species = dto.species
        self.type = dto.type
        self.gender = Gender(rawValue: dto.gender) ?? .unknown
        self.origin = CharacterOrigin(name: dto.origin.name,
                                      url: dto.origin.url)
        self.location = CharacterLocation(name: dto.location.name,
                                          url: dto.location.url)
        self.image = dto.image
        self.episode = dto.episode
    }
}

struct CharacterOrigin: Decodable {
    let name: String
    let url: String
}

struct CharacterLocation: Decodable {
    let name: String
    let url: String
}

enum Gender: String, Decodable {
    case Female
    case Male
    case Genderless
    case unknown
    
    func icon() -> String {
        switch self {
        case .Female:
            return "♀"
        case .Male:
            return "♂"
        case .Genderless:
            return "⚧"
        case .unknown:
            return "？"
        }
    }
}

enum Status: String, Decodable {
    case Alive
    case Dead
    case unknown
    
    func toQueryParams() -> String {
        switch self {
        case .Alive:
            return "status=alive"
        case .Dead:
            return "status=dead"
        case .unknown:
            return "status=unknown"
        }
    }
}
