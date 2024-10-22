//
//  CharacterUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol CharacterUseCase {
    func getCharacter(id: Int) async throws -> CharacterDTO
}

struct CharacterUseCaseImpl: CharacterUseCase {
    
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    func getCharacter(id: Int) async throws -> CharacterDTO {
        return try await repository.getCharacter(id: id)
    }
}
