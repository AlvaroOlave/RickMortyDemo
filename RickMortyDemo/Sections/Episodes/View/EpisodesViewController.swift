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
import AutolayoutDSL

final class EpisodesViewController: UIViewController {
    
    private lazy var titleImage: UIImageView = {
        let image = NavigationTitleIcon()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCell")
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.backgroundColor = .clear
        table.layer.cornerRadius = 8.0
        table.bounces = false
        return table
    }()
    
    private lazy var errorView: ErrorView = {
        let error = ErrorView()
        error.translatesAutoresizingMaskIntoConstraints = false
        error.isHidden = true
        return error
    }()
    
    private let dependencies: EpisodesDependenciesResolver
    private let viewModel: EpisodesViewModel
    private var cancellables = [AnyCancellable]()
    
    private var episodes: [Episode] = []
    
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

extension EpisodesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as? EpisodeTableViewCell
        else { return UITableViewCell(frame: .zero) }
        
        cell.setEpisode(episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.text = "Episodes"
        label.font = Fonts.markerFont(size: 32.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        label.fill(headerView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEpisodeDetail(episodes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension EpisodesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let limitIndex = episodes.count - 5
        
        if indexPaths.contains(where: { $0.row >= limitIndex }) {
            viewModel.loadMoreEpisodes()
        }
    }
}


private extension EpisodesViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleImage
        view.addSubview(tableView)
        view.addSubview(errorView)
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0 -|- view
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        errorView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0 -|- (view + 16.0)
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
                case .addEpisodes(let episodes):
                    self?.episodes.append(contentsOf: episodes)
                    self?.tableView.reloadData()
                case .showLoading(let show):
                    self?.showLoadingView(isVisible: show)
                case .showError(let error):
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func showEpisodeDetail(_ episode: Episode) {
        let episodePopup = EpisodePopup(episode)
        episodePopup.presentIn(view)
        episodePopup.$selectedCharacter
            .sink { [weak self] id in
                guard let id = id else { return }
                self?.viewModel.goToCharacter(id)
            }.store(in: &cancellables)
    }
    
    func showError(_ error: Error) {
        tableView.isHidden = true
        errorView.isHidden = false
        errorView.setErrorDescription(error.localizedDescription)
    }
}

extension EpisodesViewController: LoadingCapable {}
