//
//  RequestInfo.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

struct RequestInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
