//
//  CompleteResponseDTO.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import Foundation

struct CompleteResponseDTO<T: Decodable>: Decodable {
    let info: RequestInfoDTO
    let results: T
}
