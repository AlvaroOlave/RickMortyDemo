//
//  EpisodesViewModelTests.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import XCTest
import Combine
@testable import RickMortyDemo

final class EpisodesViewModelTests: XCTestCase {
    
   var viewModel: EpisodesViewModel!
   var mockDependencies: MockEpisodeDependencies!
   var cancellables: Set<AnyCancellable>!
    
   override func setUp() {
       super.setUp()
       mockDependencies = MockEpisodeDependencies()
       viewModel = EpisodesViewModel(dependencies: mockDependencies)
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
    
    func testLoadEpisodes_success() {
        // Given
        let episode = Episode.mockEpisode()
        mockDependencies.mockUseCase.mockEpisodes = [episode]
        let expectation = XCTestExpectation(description: "Should add episodes")
        // When
        viewModel.$state
            .dropFirst(2)
            .sink { state in
                if case .addEpisodes(let episodes) = state {
                    XCTAssertEqual(episodes.count, 1)
                    XCTAssertEqual(episodes.first?.name, episode.name)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadEpisodes_error() {
        // Given
        mockDependencies.mockUseCase.shouldThrowError = true
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
        let characterID = 1
        // When
        viewModel.goToCharacter(characterID)
        // Then
        XCTAssertTrue(mockDependencies.mockCoordinator.goToCharacterCalled)
        XCTAssertEqual(mockDependencies.mockCoordinator.characterID, characterID)
    }
    
    func testLoadMoreEpisodes_notLoadingAndHasMore() {
        // Given
        viewModel.isLoading = false
        viewModel.hasMore = true
        let episode = Episode.mockEpisode()
        mockDependencies.mockUseCase.mockEpisodes = [episode]
        let expectation = XCTestExpectation(description: "Should add more episodes")
        // When
        viewModel.$state
            .sink { state in
                if case .addEpisodes(let episodes) = state {
                    XCTAssertEqual(episodes.count, 1)
                    XCTAssertEqual(episodes.first?.name, episode.name)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadMoreEpisodes()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadMoreEpisodes_isLoadingOrNoMoreData() {
        // Given
        viewModel.isLoading = true
        viewModel.hasMore = false
        // When
        viewModel.loadMoreEpisodes()
        // Then
        XCTAssertFalse(mockDependencies.mockUseCase.isCalled)
    }
}
