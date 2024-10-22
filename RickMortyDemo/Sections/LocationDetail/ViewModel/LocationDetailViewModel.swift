//
//  
//  LocationDetailViewModel.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import Foundation
import Combine

enum LocationDetailState {
    case idle
    case showLocation(Location)
    case showLoading(Bool)
    case showError(Error)
}

final class LocationDetailViewModel {

    private let dependencies: LocationDetailDependenciesResolver
    private var cancellables = [AnyCancellable]()
    private var coordinator: LocationDetailCoordinator? {
        dependencies.resolve()
    }
    
    private lazy var locationUseCase: LocationUseCase = {
        dependencies.resolve()
    }()
    
    @Published var state: LocationDetailState = .idle
    
    init(dependencies: LocationDetailDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        if let location: Location = coordinator?.dataBinding.get() {
            state = .showLocation(location)
        } else if let id: Int = coordinator?.dataBinding.get() {
            getLocation(id)
        }
    }
    
    func goToCharacter(_ id: Int) {
        coordinator?.goToCharacter(id)
    }
}

private extension LocationDetailViewModel {
    func getLocation(_ id: Int) {
        state = .showLoading(true)
        Task {
            do {
                let dto = try await locationUseCase.getLocation(id: id)
                state = .showLocation(Location(with: dto))
                state = .showLoading(false)
            } catch {
                state = .showError(error)
                state = .showLoading(false)
            }
        }
    }
}
