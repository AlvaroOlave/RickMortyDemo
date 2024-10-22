//
//  LocationRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol LocationRepository {
    func getLocation(id: Int) async throws -> LocationDTO
}

final class LocationRepositoryImpl: LocationRepository {
    
    private let repository: Repository<LocationDTO>
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getLocation(id: Int) async throws -> LocationDTO {
        return try await repository.fetch(endpoint: Config.location + "/\(id)")
    }
}
