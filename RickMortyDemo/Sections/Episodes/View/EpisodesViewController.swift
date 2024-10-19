//
//  
//  EpisodesViewController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit
import Combine

final class EpisodesViewController: UIViewController {
    
    private let dependencies: EpisodesDependenciesResolver
    private let viewModel: EpisodesViewModel
    private var cancellables = [AnyCancellable]()
    
    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension EpisodesViewController {}

private extension EpisodesViewController {
    func setupView() {
        
    }
    
    func bindViewModel() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .idle:
                    break
                case .addEpisodes(let episodes):
                    print("EPISODES")
                    print(episodes)
                case .showLoading(let show):
                    print(show)
                case .showError(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
}
