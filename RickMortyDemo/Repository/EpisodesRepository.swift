//
//  EpisodesRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol EpisodesRepository {
    func getEpisodes() async throws -> [Episode]
}

final class EpisodesRepositoryImpl: EpisodesRepository {
    
    private let repository: Repository<CompleteResponse<[Episode]>>
    
    internal var currentPage = 0
    internal var hasMorePages = true
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getEpisodes() async throws -> [Episode] {
        guard hasMorePages else { return [] }
        let completeResponse = try await repository.fetch(endpoint: Config.episode, page: currentPage)
        manageInfo(completeResponse.info)
        return completeResponse.results
    }
}

extension EpisodesRepositoryImpl: ManageResponseInfo {}
