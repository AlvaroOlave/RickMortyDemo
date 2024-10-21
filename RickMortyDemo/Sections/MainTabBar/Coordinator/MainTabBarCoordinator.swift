//
//  
//  MainTabBarCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit

protocol MainTabBarCoordinator: Coordinator {
    
}

final class MainTabBarCoordinatorImpl: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: MainTabBarExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    init(dependencies: MainTabBarExternalDependenciesResolver) {
        self.externalDependencies = dependencies
    }

    func start() {
        addChildCoordinators()
        let window: UIWindow = dependencies.external.resolve()
        window.rootViewController = dependencies.resolve()
        window.makeKeyAndVisible()
    }
}

extension MainTabBarCoordinatorImpl: MainTabBarCoordinator {
    
}

private extension MainTabBarCoordinatorImpl {
    struct Dependency: MainTabBarDependenciesResolver {
        let external: MainTabBarExternalDependenciesResolver
        weak var coordinator: MainTabBarCoordinator?
        
        func resolve() -> MainTabBarCoordinator? {
            return coordinator
        }
    }
    
    func addChildCoordinators() {
        let charactersCoordinator = dependencies.external.charactersCoordinator()
        charactersCoordinator.start()
        append(child: charactersCoordinator)
        
        let locationsCoordinator = dependencies.external.locationsCoordinator()
        locationsCoordinator.start()
        append(child: locationsCoordinator)
        
        let episodesCoordinator = dependencies.external.episodesCoordinator()
        episodesCoordinator.start()
        append(child: episodesCoordinator)
    }
}
