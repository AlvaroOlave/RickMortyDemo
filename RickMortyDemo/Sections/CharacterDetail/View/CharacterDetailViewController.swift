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
    
    private lazy var placeholder: UIImage? = {
        UIImage(named: "rmPlaceholder")
    }()
    
    private lazy var characterImage: UIImageView = {
        let image = UIImageView(image: placeholder)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var characterSpecies: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var characterStatus: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var originView: OriginView = {
        let view = OriginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currentLocationView: OriginView = {
        let view = OriginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var episodesListView: EpisodesListView = {
        let view = EpisodesListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(containerView)
        scrollableStackView.addArrangedSubviews(characterImage,
                                                characterSpecies,
                                                characterStatus,
                                                originView,
                                                currentLocationView,
                                                episodesListView)
        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.layout {
            $0 -|- (view + 16.0)
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
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
                    self?.setupCharacter(character)
                case .showLoading(let show):
                    print(show)
                case .showError(let error):
                    print(error)
                case .showEpisode(let episode):
                    self?.showEpisodePopup(episode)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupCharacter(_ character: Character) {
        titleLabel.text = character.name
        if let url = URL(string: character.image) {
            ImageLoader.shared.loadImage(from: url,
                                         placeholder: placeholder) { [weak self] img in
                self?.characterImage.image = img
            }
        }
        
        characterSpecies.text = "Species: \(character.species), \(character.gender)"
        characterStatus.text = "Status: \(character.status)"
        originView.setOrigin("Origin: \(character.origin.name)")
        
        originView.addGestureRecognizer(LocationTapGesture(id: idFromURL(character.origin.url),
                                                           target: self,
                                                           action: #selector(goToLocation)))
        currentLocationView.setOrigin("Current location: \(character.location.name)")
        currentLocationView.addGestureRecognizer(LocationTapGesture(id: idFromURL(character.location.url),
                                                                    target: self,
                                                                    action: #selector(goToLocation)))
        let episodeIds = character.episode.map({ idFromURL($0)}).compactMap({ $0 })
        if !episodeIds.isEmpty {
            episodesListView.setupEpisodes(episodeIds)
            episodesListView.$selectedEpisode
                .sink { [weak self] id in
                    guard let id = id else { return }
                    self?.viewModel.loadEpisode(id)
                }
                .store(in: &cancellables)
        }
    }
    
    @objc func goToLocation(sender : LocationTapGesture) {
        guard let id = sender.id else { return }
        viewModel.goToLocation(id)
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
}

final class LocationTapGesture: UITapGestureRecognizer {
    let id: Int?
    
    init(id: Int?, target: Any?, action: Selector?) {
        self.id = id
        super.init(target: target, action: action)
    }
}
