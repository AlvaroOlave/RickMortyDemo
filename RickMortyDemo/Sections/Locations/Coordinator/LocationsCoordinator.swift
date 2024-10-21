//
//  
//  LocationsCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit

protocol LocationsCoordinator: Coordinator {
    func goToLocation(_ location: Location)
}

final class LocationsCoordinatorImpl: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: LocationsExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    init(dependencies: LocationsExternalDependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.externalDependencies = dependencies
    }

    func start() {
        navigationController?.pushViewController(dependencies.resolve(),
                                                 animated: false)
    }
}

extension LocationsCoordinatorImpl: LocationsCoordinator {
    func goToLocation(_ location: Location) {
        let coordinator = dependencies.external.locationDetailCoordinator()
        coordinator
            .set(navigationController)
            .set(location)
            .start()
        append(child: coordinator)
    }
}

private extension LocationsCoordinatorImpl {
    struct Dependency: LocationsDependenciesResolver {
        let external: LocationsExternalDependenciesResolver
        weak var coordinator: LocationsCoordinator?
        
        func resolve() -> LocationsCoordinator? {
            return coordinator
        }
    }
}
