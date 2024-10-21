//
//  
//  LocationDetailViewController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL

final class LocationDetailViewController: UIViewController {
    
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
    
    private lazy var planetInfo: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var charactersListView: CharactersListView = {
        let view = CharactersListView(mainColor: Colors.rmBlue,
                                      secondaryColor: Colors.rmPurple)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dependencies: LocationDetailDependenciesResolver
    private let viewModel: LocationDetailViewModel
    private var cancellables = [AnyCancellable]()
    
    init(dependencies: LocationDetailDependenciesResolver) {
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

extension LocationDetailViewController {}

private extension LocationDetailViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = Colors.rmBlue
        view.addSubview(containerView)
        scrollableStackView.addArrangedSubviews(planetInfo)
        scrollableStackView.addArrangedSubviews(charactersListView)
        
        setupConstraints()
        
        charactersListView.$selectedCharacter
            .sink { [weak self] id in
                self?.goToCharacter(id)
            }.store(in: &cancellables)
    }
    
    func setupConstraints() {
        containerView.layout {
            $0 -|- (view + 16.0)
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
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
                case .showLocation(let location):
                    self?.setupLocation(location)
                case .showLoading(let show):
                    print(show)
                case .showError(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func goToCharacter(_ id: Int?) {
        guard let id = id else { return }
        viewModel.goToCharacter(id)
    }
    
    func setupLocation(_ location: Location) {
        titleLabel.text = location.name
        navigationItem.titleView = titleLabel
        planetInfo.text = "\(location.type) in \(location.dimension)"
        charactersListView.setupCharacters(location.residents.map({ idFromURL($0)}).compactMap({ $0 }))
    }
    
    func idFromURL(_ url: String) -> Int? {
        guard let id = url
            .components(separatedBy: "/")
            .last
        else { return nil }
        return Int(id)
    }
}
