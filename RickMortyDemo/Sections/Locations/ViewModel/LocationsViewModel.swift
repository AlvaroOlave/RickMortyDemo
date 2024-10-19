//
//  
//  LocationsViewModel.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import Foundation
import Combine

enum LocationsState {
    case idle
    case addLocations([Location])
    case showLoading(Bool)
    case showError(Error)
}

final class LocationsViewModel {

    private let dependencies: LocationsDependenciesResolver
    
    private var coordinator: LocationsCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var locationsUseCase: LocationsUseCase = {
        dependencies.resolve()
    }()
    
    private var isLoading = false
    
    @Published var state: LocationsState = .idle
    
    init(dependencies: LocationsDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        state = .showLoading(true)
        loadLocations()
    }
    
    func loadMoreLocations() {
        guard !isLoading else { return }
        loadLocations()
    }
}

private extension LocationsViewModel {
    func loadLocations() {
        Task {
            isLoading = true
            do {
                let locations = try await locationsUseCase.getLocations()
                state = .addLocations(locations)
                state = .showLoading(false)
                isLoading = false
            } catch {
                state = .showError(error)
                state = .showLoading(false)
                isLoading = false
            }
        }
    }
}