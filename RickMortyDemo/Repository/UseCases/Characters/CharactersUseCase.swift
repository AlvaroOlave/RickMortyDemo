//
//  CharactersUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol CharactersUseCase {
    func getCharacters() async throws -> [CharacterDTO]
    func reset()
}

struct CharactersUseCaseImpl: CharactersUseCase {
    
    private let repository: CharactersRepository
    
    init(repository: CharactersRepository) {
        self.repository = repository
    }
    
    func getCharacters() async throws -> [CharacterDTO] {
        return try await repository.getCharacters()
    }
    
    func reset() {
        repository.reset()
    }
}
