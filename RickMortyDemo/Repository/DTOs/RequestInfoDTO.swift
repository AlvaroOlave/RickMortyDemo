//
//  RequestInfoDTO.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import Foundation

struct RequestInfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
