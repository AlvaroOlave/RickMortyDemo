//
//  CharacterDTO.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct CharacterOriginDTO: Decodable {
    let name: String
    let url: String
}

struct CharacterLocationDTO: Decodable {
    let name: String
    let url: String
}
