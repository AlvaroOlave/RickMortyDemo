//
//  
//  CharacterDetailCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit

protocol CharacterDetailCoordinator: BindableCoordinator {
    func goToLocation(_ id: Int)
    func goToCharacter(_ id: Int)
}

final class CharacterDetailCoordinatorImpl: NSObject, BindableCoordinator {
    var dataBinding: DataBinding
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: CharacterDetailExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    init(dependencies: CharacterDetailExternalDependenciesResolver) {
        self.externalDependencies = dependencies
        self.dataBinding = DataBindingObject()
    }
    
    deinit {
        childCoordinators.removeAll()
        dataBinding.clear()
    }

    func start() {
        let vc: CharacterDetailViewController = dependencies.resolve()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController = dataBinding.get()
        navigationController?.delegate = self
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

extension CharacterDetailCoordinatorImpl: CharacterDetailCoordinator {
    func goToLocation(_ id: Int) {
        let coordinator = dependencies.external.locationDetailCoordinator()
        coordinator
            .set(navigationController)
            .set(id)
            .start()
        append(child: coordinator)
    }
    
    func goToCharacter(_ id: Int) {
        let coordinator = dependencies.external.characterDetailCoordinator()
        coordinator
            .set(navigationController)
            .set(id)
            .start()
        append(child: coordinator)
    }
}

extension CharacterDetailCoordinatorImpl: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.navigationController?.viewControllers.first {
            self.navigationController?.delegate = nil
            dismiss()
        }
    }
}

private extension CharacterDetailCoordinatorImpl {
    struct Dependency: CharacterDetailDependenciesResolver {
        let external: CharacterDetailExternalDependenciesResolver
        weak var coordinator: CharacterDetailCoordinator?
        
        func resolve() -> CharacterDetailCoordinator? {
            return coordinator
        }
    }
}
