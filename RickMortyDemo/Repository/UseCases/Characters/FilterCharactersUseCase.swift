//
//  FilterCharactersUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 23/10/24.
//

import Foundation

protocol FilterCharactersUseCase {
    func getCharacter(params: [String]) async throws -> [CharacterDTO]
}

struct FilterCharactersUseCaseImpl: FilterCharactersUseCase {
    
    private let repository: FilterCharactersRepository
    
    init(repository: FilterCharactersRepository) {
        self.repository = repository
    }
    
    func getCharacter(params: [String]) async throws -> [CharacterDTO] {
        return try await repository.getCharacters(params: params)
    }
}
