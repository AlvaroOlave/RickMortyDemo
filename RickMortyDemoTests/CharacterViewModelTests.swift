//
//  CharacterViewModelTests.swift
//  RickMortyDemoTests
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import XCTest
import Combine
@testable import RickMortyDemo

final class CharacterDetailViewModelTests: XCTestCase {
    
    private var viewModel: CharacterDetailViewModel!
    private var mockDependencies: MockCharacterDetailDependenciesResolver!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDependencies = MockCharacterDetailDependenciesResolver()
        viewModel = CharacterDetailViewModel(dependencies: mockDependencies)
        cancellables = []
    }
    
    override func tearDown() {
        mockDependencies = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoad_showCharacterFromDataBinding() {
        // Given
        let dto = CharacterDTO.mockCharacter(id: 1)
        let character = Character(with: dto)
        mockDependencies.mockCoordinator.dataBinding.set(character)
        let expectation = XCTestExpectation(description: "Should show character")
        // When
        viewModel.$state
            .sink { state in
                if case .showCharacter(let receivedCharacter) = state {
                    XCTAssertEqual(receivedCharacter.id, character.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testViewDidLoad_loadCharacterById() {
        // Given
        let character = CharacterDTO.mockCharacter(id: 1)
        mockDependencies.mockCoordinator.dataBinding.set(1)
        mockDependencies.mockCharacterUseCase.mockCharacter = character
        let expectation = self.expectation(description: "Load character")
        // When
        viewModel.$state
            .sink { state in
                if case .showCharacter(let loadedCharacter) = state {
                    XCTAssertEqual(loadedCharacter.id, character.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.viewDidLoad()
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadEpisode_success() {
        // Given
        let episode = EpisodeDTO.mockEpisode(id: 1)
        mockDependencies.mockEpisodeUseCase.mockedEpisode = episode
        let expectation = self.expectation(description: "Load episode")
        // When
        viewModel.$state
            .sink { state in
                if case .showEpisode(let loadedEpisode) = state {
                    XCTAssertEqual(loadedEpisode.id, episode.id)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadEpisode(1)
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadEpisode_failure() {
        // Given
        mockDependencies.mockEpisodeUseCase.shouldThrowError = true
        let expectation = self.expectation(description: "Should show error")
        // When
        viewModel.$state
            .sink { state in
                if case .showError(let error) = state {
                    XCTAssertEqual(error.localizedDescription, "Mock error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadEpisode(1)
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
