//
//  CharactersUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol CharactersUseCase {
    func getCharacters() async throws -> [Character]
}

struct CharactersUseCaseImpl: CharactersUseCase {
    
    private let repository: CharactersRepository
    
    init(repository: CharactersRepository) {
        self.repository = repository
    }
    
    func getCharacters() async throws -> [Character] {
        return try await repository.getCharacters()
    }
}
