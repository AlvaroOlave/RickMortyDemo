//
//  EpisodesUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol EpisodesUseCase {
    func getEpisodes() async throws -> [EpisodeDTO]
}

struct EpisodesUseCaseImpl: EpisodesUseCase {
    
    private let repository: EpisodesRepository
    
    init(repository: EpisodesRepository) {
        self.repository = repository
    }
    
    func getEpisodes() async throws -> [EpisodeDTO] {
        return try await repository.getEpisodes()
    }
}
