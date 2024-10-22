//
//  Repository.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation

class Repository<T: Decodable> {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetch(endpoint: String, page: Int? = nil) async throws -> T {
        var urlString = baseURL+endpoint
        if let page = page {
            urlString += "/?page=\(page)"
        }
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}

protocol ManageResponseInfo: AnyObject {
    var currentPage: Int { get set }
    var hasMorePages: Bool { get set }
}

extension ManageResponseInfo {
    func manageInfo(_ info: RequestInfoDTO) {
        guard let next = info.next,
                let nextURL = URL(string: next),
              let page = nextURL
            .query()?
            .components(separatedBy: "=")
            .last,
              let pageInt = Int(page)
        else { return hasMorePages = false }
        currentPage = pageInt
    }
}
