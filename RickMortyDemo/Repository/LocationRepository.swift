//
//  LocationRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation

protocol LocationRepository {
    func getLocation(id: Int) async throws -> Location
}

final class LocationRepositoryImpl: LocationRepository {
    
    private let repository: Repository<Location>
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getLocation(id: Int) async throws -> Location {
        return try await repository.fetch(endpoint: Config.location + "/\(id)")
    }
}
