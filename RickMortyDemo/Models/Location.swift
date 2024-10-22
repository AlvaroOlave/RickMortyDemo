//
//  Location.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    
    init(with dto: LocationDTO) {
        self.id = dto.id
        self.name = dto.name
        self.type = dto.type
        self.dimension = dto.dimension
        self.residents = dto.residents
    }
}
