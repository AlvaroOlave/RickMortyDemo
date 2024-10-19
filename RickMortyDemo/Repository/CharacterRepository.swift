//
//  CharacterRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol CharacterRepository {
    func getCharacters() async throws -> [Character]
}

final class CharacterRepositoryImpl: CharacterRepository {
    
    private let repository: Repository<CompleteResponse<[Character]>>
    
    internal var currentPage = 0
    internal var hasMorePages = true
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getCharacters() async throws -> [Character] {
        guard hasMorePages else { return [] }
        let completeResponse = try await repository.fetch(endpoint: Config.character, page: currentPage)
        manageInfo(completeResponse.info)
        return completeResponse.results
    }
}

extension CharacterRepositoryImpl: ManageResponseInfo {}
