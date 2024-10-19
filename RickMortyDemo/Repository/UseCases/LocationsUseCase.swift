//
//  LocationsUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol LocationsUseCase {
    func getLocations() async throws -> [Location]
}

struct LocationsUseCaseImpl: LocationsUseCase {
    
    private let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
    
    func getLocations() async throws -> [Location] {
        return try await repository.getLocations()
    }
}
