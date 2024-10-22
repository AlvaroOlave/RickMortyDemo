//
//  CharactersViewModelTests.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import XCTest
import Combine
@testable import RickMortyDemo

final class CharactersViewModelTests: XCTestCase {
    
    var viewModel: CharactersViewModel!
    var mockDependencies: MockCharactersDependencies!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDependencies = MockCharactersDependencies()
        viewModel = CharactersViewModel(dependencies: mockDependencies)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDependencies = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoad_showLoading() {
        // Given
        let expectation = XCTestExpectation(description: "Starts with isLoading == true")
        // When
        viewModel.$state
            .dropFirst()
            .first()
            .sink { state in
                if case .showLoading(let isLoading) = state {
                    XCTAssertTrue(isLoading)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadCharacters_success() {
        // Given
        let character = CharacterDTO.mockCharacter(id: 0)
        mockDependencies.mockUseCase.mockCharacters = [character]
        let expectation = XCTestExpectation(description: "Should return given character")
        // When
        viewModel.$state
            .sink { state in
                if case .addCharacters(let characters) = state {
                    XCTAssertEqual(characters.count, 1)
                    XCTAssertEqual(characters.first?.first?.id, character.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadCharacters_error() {
        // Given
        mockDependencies.mockUseCase.shouldThrowError = true
        let expectation = XCTestExpectation(description: "Should throw error state")
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
    
    func testGoToDetail() {
        // Given
        let dto = CharacterDTO.mockCharacter(id: 0)
        let character = Character(with: dto)
        // When
        viewModel.goToDetail(character)
        // Then
        XCTAssertTrue(mockDependencies.mockCoordinator.goToDetailCalled)
    }
    
    func testLoadMoreCharacters_notLoadingAndHasMore() {
        // Given
        viewModel.isLoading = false
        viewModel.hasMore = true
        let character = CharacterDTO.mockCharacter(id: 0)
        mockDependencies.mockUseCase.mockCharacters = [character]
        let expectation = XCTestExpectation(description: "Should load more characters")
        // When
        viewModel.$state
            .sink { state in
                if case .addCharacters(let characters) = state {
                    XCTAssertEqual(characters.count, 1)
                    XCTAssertEqual(characters.first?.first?.name, character.name)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadMoreCharacters()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadMoreCharacters_isLoadingOrNoMoreData() {
        // Given
        viewModel.isLoading = true
        viewModel.hasMore = false
        // When
        viewModel.loadMoreCharacters()
        // Then
        XCTAssertFalse(mockDependencies.mockUseCase.isCalled)
    }
}
