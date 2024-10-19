//
//  LocationRepository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

protocol LocationRepository {
    func getLocations() async throws -> [Location]
}

final class LocationRepositoryImpl: LocationRepository {
    
    private let repository: Repository<CompleteResponse<[Location]>>
    
    internal var currentPage = 0
    internal var hasMorePages = true
    
    init(baseURL: String) {
        self.repository = Repository(baseURL: baseURL)
    }
    
    func getLocations() async throws -> [Location] {
        guard hasMorePages else { return [] }
        let completeResponse = try await repository.fetch(endpoint: Config.location, page: currentPage)
        manageInfo(completeResponse.info)
        return completeResponse.results
    }
}

extension LocationRepositoryImpl: ManageResponseInfo {}
