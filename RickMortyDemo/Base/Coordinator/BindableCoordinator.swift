//
//  BindableCoordinator.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 18/10/24.
//

import Foundation

typealias BindableCoordinator = Coordinator & Bindable

protocol Bindable {
    var dataBinding: DataBinding { get }
    func set<T>(_ value: T) -> Self
}

extension Bindable {
    @discardableResult
    func set<T>(_ value: T) -> Self {
        dataBinding.set(value)
        return self
    }
}

typealias DatabindingPredicate = (Any) -> Bool

protocol DataBinding {
    func get<T>() -> T?
    func get<T>(_ predicate: DatabindingPredicate?) -> T?
    func set<T>(_ value: T)
    func contains<T>(_ type: T.Type) -> Bool
    func clear()
}

class DataBindingObject: DataBinding {
    private var values: [Any] = []
    public init() {}
    public func get<T>() -> T? {
        return getElement()
    }
    public func get<T>(_ predicate: DatabindingPredicate? = nil) -> T? {
        return getElement(predicate: predicate)
    }
    public func set<T>(_ value: T) {
        defer { self.values.append(value) }
        guard let index = values.firstIndex(where: { $0 is T || $0 is T? }) else { return }
        values.remove(at: index)
    }
    public func contains<T>(_ type: T.Type) -> Bool {
        return values.contains(where: { $0 is T })
    }
    public func clear() {
        values.removeAll()
    }
}
private extension DataBindingObject {
    func getElement<T>(predicate: DatabindingPredicate? = nil) -> T? {
        let wherePredicate = predicate ?? { $0 is T || $0 is T? }
        guard let index = values.firstIndex(where: wherePredicate),
        let value = values[index] as? Optional<T> else {
           return nil
        }
        return value
    }
}
