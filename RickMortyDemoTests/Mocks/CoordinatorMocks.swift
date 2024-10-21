//
//  Mocks.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import UIKit
@testable import RickMortyDemo

class MockCoordinator: Coordinator {
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    func start() { }
}

class MockBindableCoordinator: BindableCoordinator {
    var dataBinding: DataBinding = DataBindingObject()
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    func start() { }
}

class MockCharactersCoordinator: MockCoordinator, CharactersCoordinator {
    
    var goToDetailCalled = false
    var character: Character?
    
    func goToDetail(_ character: Character) {
        goToDetailCalled = true
        self.character = character
    }
}

class MockEpisodesCoordinator: MockCoordinator, EpisodesCoordinator {
    
    var goToCharacterCalled = false
    var characterID: Int?
    
    func goToCharacter(_ id: Int) {
        goToCharacterCalled = true
        characterID = id
    }
}

class MockLocationDetailCoordinator: MockBindableCoordinator, LocationDetailCoordinator {
    var goToCharacterCalled = false
    var characterID: Int?
    
    func goToCharacter(_ id: Int) {
        goToCharacterCalled = true
        characterID = id
    }
}

class MockCharacterDetailCoordinator: MockBindableCoordinator, CharacterDetailCoordinator {
    var mockedCharacter: Character?
    var mockedId: Int?
    var calledGoToLocation = false
    var calledGoToCharacter = false
    
    override init() {
        super.init()
        if let character = mockedCharacter {
            dataBinding.set(character)
        } else if let id = mockedId {
            dataBinding.set(id)
        }
    }
    
    func goToLocation(_ id: Int) {
        calledGoToLocation = true
    }
    
    func goToCharacter(_ id: Int) {
        calledGoToCharacter = true
    }
}
