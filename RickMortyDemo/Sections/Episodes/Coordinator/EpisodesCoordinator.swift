//
//  
//  EpisodesCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit

protocol EpisodesCoordinator: Coordinator {
    
}

final class EpisodesCoordinatorImpl: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: EpisodesExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: EpisodesExternalDependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.externalDependencies = dependencies
    }

    func start() {
        navigationController?.pushViewController(dependencies.resolve(),
                                                 animated: false)
    }
}

extension EpisodesCoordinatorImpl: EpisodesCoordinator {
    
}

private extension EpisodesCoordinatorImpl {
    struct Dependency: EpisodesDependenciesResolver {
        let external: EpisodesExternalDependenciesResolver
        weak var coordinator: EpisodesCoordinator?
        
        func resolve() -> EpisodesCoordinator? {
            return coordinator
        }
    }
}
