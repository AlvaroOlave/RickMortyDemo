//
//  CharactersRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol CharactersRepository {
    func getCharacters() async throws -> [CharacterDTO]
    func reset()
}

final class CharactersRepositoryImpl: CharactersRepository {
    
    private let repository: Repository<CompleteResponseDTO<[CharacterDTO]>>
    
    internal var currentPage = 0
    internal var hasMorePages = true
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getCharacters() async throws -> [CharacterDTO] {
        guard hasMorePages else { return [] }
        let completeResponse = try await repository.fetch(endpoint: Config.character, 
                                                          page: currentPage)
        manageInfo(completeResponse.info)
        return completeResponse.results
    }
    
    func reset() {
        currentPage = 0
        hasMorePages = true
    }
}

extension CharactersRepositoryImpl: ManageResponseInfo {}
