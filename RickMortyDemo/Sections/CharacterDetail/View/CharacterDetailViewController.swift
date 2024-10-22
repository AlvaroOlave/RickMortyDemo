//
//  
//  CharacterDetailViewController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL
import SwiftUI

final class CharacterDetailViewController: UIViewController {
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.setSpacing(12.0)
        view.setup(with: self.containerView)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 24.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var errorView: ErrorView = {
        let error = ErrorView()
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()
    
    private let dependencies: CharacterDetailDependenciesResolver
    private let viewModel: CharacterDetailViewModel
    private var cancellables = [AnyCancellable]()
    
    private var episodePopup: EpisodePopup?
    
    init(dependencies: CharacterDetailDependenciesResolver) {
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
}

private extension CharacterDetailViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = Colors.rmBlue
    }
    
    func bindViewModel() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .showCharacter(let character):
                    self?.setupHostedView(character)
                case .showLoading(let show):
                    self?.showLoadingView(isVisible: show)
                case .showError(let error):
                    self?.showError(error)
                case .showEpisode(let episode):
                    self?.showEpisodePopup(episode)
                }
            }
            .store(in: &cancellables)
    }
    
    func idFromURL(_ url: String) -> Int? {
        guard let id = url
            .components(separatedBy: "/")
            .last
        else { return nil }
        return Int(id)
    }
    
    func showEpisodePopup(_ episode: Episode) {
        episodePopup = EpisodePopup(episode)
        episodePopup?.$selectedCharacter
            .sink { [weak self] id in
                self?.goToCharacter(id)
            }
            .store(in: &cancellables)
        episodePopup?.presentIn(view)
    }
    
    func goToCharacter(_ id: Int?) {
        guard let id = id else { return }
        episodePopup?.dismiss()
        viewModel.goToCharacter(id)
    }
    
    func showError(_ error: Error) {
        errorView.setErrorDescription(error.localizedDescription)
        scrollableStackView.addArrangedSubviews(errorView)
    }
    
    func setupHostedView(_ character: Character) {
        titleLabel.text = character.name
        let host = UIHostingController(rootView: CharacterDetailView(character: character, 
                                                                     selectedLocation: { [weak self] url in
            guard let id = self?.idFromURL(url) else { return }
            self?.viewModel.goToLocation(id)
        }, selectedEpisode: { [weak self] id in
            guard let id = id else { return }
            self?.viewModel.loadEpisode(id)
        }))
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.fill(view)
        host.didMove(toParent: self)
    }
}

extension CharacterDetailViewController: LoadingCapable {}
