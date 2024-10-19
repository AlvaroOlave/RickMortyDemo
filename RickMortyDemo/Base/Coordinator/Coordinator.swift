//
//  Coordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 18/10/24.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject, UniqueIdentifiable {
    var identifier: String { get }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    var onFinish: (() -> Void)? { get set }
    func start()
    func dismiss()
}

extension Coordinator {
    var identifier: String {
        return String(describing: self)
    }
    
    var uniqueIdentifier: Int {
        return identifier.hashValue
    }
    
    var onFinish: (() -> Void)? {
        return nil
    }

    func append(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.childCoordinators.remove(coordinator)
        }
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
        onFinish?()
    }
}

extension Array where Element == Coordinator {
    mutating func remove(_ coordinator: Coordinator) {
        removeAll(where: { coordinator.identifier == $0.identifier })
    }
}

public protocol UniqueIdentifiable {
    var uniqueIdentifier: Int { get }
}

func ==<T: UniqueIdentifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.uniqueIdentifier == rhs.uniqueIdentifier
}

