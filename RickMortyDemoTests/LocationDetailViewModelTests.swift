//
//  LocationDetailViewModelTests.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import XCTest
import Combine
@testable import RickMortyDemo

final class LocationDetailViewModelTests: XCTestCase {
    
    var viewModel: LocationDetailViewModel!
    var mockDependencies: MockLocationDependencies!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDependencies = MockLocationDependencies()
        viewModel = LocationDetailViewModel(dependencies: mockDependencies)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDependencies = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoad_showsLocationFromCoordinator() {
        // Given
        let location = Location.mockLocation(id: 1)
        mockDependencies.mockCoordinator.dataBinding.set(location)
        let expectation = XCTestExpectation(description: "Should show location")
        // When
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .showLocation(let receivedLocation) = state {
                    XCTAssertEqual(receivedLocation.id, location.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testViewDidLoad_fetchesLocationByID() {
        // Given
        let location = Location.mockLocation(id: 1)
        mockDependencies.mockUseCase.mockLocation = location
        mockDependencies.mockCoordinator.dataBinding.set(1)
        let expectation = XCTestExpectation(description: "Should fetch location by ID")
        // When
        viewModel.$state
            .sink { state in
                if case .showLocation(let receivedLocation) = state {
                    XCTAssertEqual(receivedLocation.id, location.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetLocation_showsErrorOnFailure() {
        // Given
        mockDependencies.mockUseCase.shouldThrowError = true
        mockDependencies.mockCoordinator.dataBinding.set(1)
        let expectation = XCTestExpectation(description: "Should show error")
        // When
        viewModel.$state
            .sink { state in
                if case .showError(let error) = state {
                    XCTAssertEqual(error.localizedDescription, "Mock error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGoToCharacter() {
        // Given
        let characterID = 0
        // When
        viewModel.goToCharacter(characterID)
        // Then
        XCTAssertTrue(mockDependencies.mockCoordinator.goToCharacterCalled)
        XCTAssertEqual(mockDependencies.mockCoordinator.characterID, characterID)
    }
}
