//
//  
//  LocationDetailCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit

protocol LocationDetailCoordinator: BindableCoordinator {
    func goToCharacter(_ id: Int)
}

final class LocationDetailCoordinatorImpl: NSObject, BindableCoordinator {
    var dataBinding: DataBinding
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    private let externalDependencies: LocationDetailExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies,
                   coordinator: self)
    }()
    
    init(dependencies: LocationDetailExternalDependenciesResolver) {
        self.externalDependencies = dependencies
        self.dataBinding = DataBindingObject()
    }
    
    deinit {
        childCoordinators.removeAll()
        dataBinding.clear()
    }
    
    func start() {
        let vc: LocationDetailViewController = dependencies.resolve()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController = dataBinding.get()
        navigationController?.delegate = self
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

extension LocationDetailCoordinatorImpl: LocationDetailCoordinator {
    func goToCharacter(_ id: Int) {
        let coordinator = dependencies.external.characterDetailCoordinator()
        coordinator
            .set(navigationController)
            .set(id)
            .start()
        append(child: coordinator)
    }
}

extension LocationDetailCoordinatorImpl: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.navigationController?.viewControllers.first {
            self.navigationController?.delegate = nil
            dismiss()
        }
    }
}

private extension LocationDetailCoordinatorImpl {
    struct Dependency: LocationDetailDependenciesResolver {
        let external: LocationDetailExternalDependenciesResolver
        weak var coordinator: LocationDetailCoordinator?
        
        func resolve() -> LocationDetailCoordinator? {
            return coordinator
        }
    }
}
