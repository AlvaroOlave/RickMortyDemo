//
//  EpisodeRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol EpisodeRepository {
    func getEpisode(id: Int) async throws -> Episode
}

final class EpisodeRepositoryImpl: EpisodeRepository {
    
    private let repository: Repository<Episode>
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getEpisode(id: Int) async throws -> Episode {
        return try await repository.fetch(endpoint: Config.episode + "/\(id)")
    }
}
