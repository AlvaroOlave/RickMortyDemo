//
//  FilterCharactersRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 23/10/24.
//

import Foundation

protocol FilterCharactersRepository {
    func getCharacters(params: [String]) async throws -> [CharacterDTO]
    func reset()
}

final class FilterCharactersRepositoryImpl: FilterCharactersRepository {
    
    private let repository: Repository<CompleteResponseDTO<[CharacterDTO]>>
    
    internal var currentPage = 0
    internal var hasMorePages = true
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getCharacters(params: [String]) async throws -> [CharacterDTO] {
        guard hasMorePages else { return [] }
        let completeParams = (params + ["page=\(currentPage)"]).joined(separator: "&")
        let completeResponse = try await repository.fetch(endpoint: Config.character + "/?\(completeParams)")
        manageInfo(completeResponse.info)
        return completeResponse.results
    }
    
    func reset() {
        currentPage = 0
        hasMorePages = true
    }
}

extension FilterCharactersRepositoryImpl: ManageResponseInfo {}
