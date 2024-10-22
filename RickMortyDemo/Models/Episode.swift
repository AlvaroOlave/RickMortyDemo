//
//  Episode.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    
    init(with dto: EpisodeDTO) {
        self.id = dto.id
        self.name = dto.name
        self.air_date = dto.air_date
        self.episode = dto.episode
        self.characters = dto.characters
    }
}
