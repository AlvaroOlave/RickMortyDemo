//
//  EpisodeUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol EpisodeUseCase {
    func getEpisode(id: Int) async throws -> Episode
}

struct EpisodeUseCaseImpl: EpisodeUseCase {
    
    private let repository: EpisodeRepository
    
    init(repository: EpisodeRepository) {
        self.repository = repository
    }
    
    func getEpisode(id: Int) async throws -> Episode {
        return try await repository.getEpisode(id: id)
    }
}
