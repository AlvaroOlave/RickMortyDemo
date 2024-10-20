//
//  LocationUseCase.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol LocationUseCase {
    func getLocation(id: Int) async throws -> Location
}

struct LocationUseCaseImpl: LocationUseCase {
    
    private let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
    
    func getLocation(id: Int) async throws -> Location {
        return try await repository.getLocation(id: id)
    }
}