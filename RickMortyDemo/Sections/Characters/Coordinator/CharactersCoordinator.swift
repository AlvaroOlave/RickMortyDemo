//
//  
//  CharactersCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit

protocol CharactersCoordinator: Coordinator {
    
}

final class CharactersCoordinatorImpl: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: CharactersExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    public init(dependencies: CharactersExternalDependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.externalDependencies = dependencies
    }

    func start() {
        navigationController?.pushViewController(dependencies.resolve(),
                                                 animated: false)
    }
}

extension CharactersCoordinatorImpl: CharactersCoordinator {
    
}

private extension CharactersCoordinatorImpl {
    struct Dependency: CharactersDependenciesResolver {
        let external: CharactersExternalDependenciesResolver
        weak var coordinator: CharactersCoordinator?
        
        func resolve() -> CharactersCoordinator? {
            return coordinator
        }
    }
}
