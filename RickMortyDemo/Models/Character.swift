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
    let url: String
    let created: String
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
}
