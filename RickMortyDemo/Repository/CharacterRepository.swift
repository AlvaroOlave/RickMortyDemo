//
//  CharacterRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol CharacterRepository {
    func getCharacter(id: Int) async throws -> Character
}

final class CharacterRepositoryImpl: CharacterRepository {
    
    private let repository: Repository<Character>
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getCharacter(id: Int) async throws -> Character {
        return try await repository.fetch(endpoint: Config.character + "/\(id)")
    }
}
