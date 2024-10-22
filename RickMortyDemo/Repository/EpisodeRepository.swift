//
//  EpisodeRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol EpisodeRepository {
    func getEpisode(id: Int) async throws -> EpisodeDTO
}

final class EpisodeRepositoryImpl: EpisodeRepository {
    
    private let repository: Repository<EpisodeDTO>
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getEpisode(id: Int) async throws -> EpisodeDTO {
        return try await repository.fetch(endpoint: Config.episode + "/\(id)")
    }
}
