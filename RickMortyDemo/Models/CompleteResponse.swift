//
//  CompleteResponse.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

struct CompleteResponse<T: Decodable>: Decodable {
    let info: RequestInfo
    let results: T
}
