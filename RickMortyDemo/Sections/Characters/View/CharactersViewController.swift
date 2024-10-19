//
//  
//  CharactersViewController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL

final class CharactersViewController: UIViewController {
    
    private lazy var titleImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Rick_and_Morty_Logo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.setSpacing(32.0)
        view.setup(with: self.containerView)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = Fonts.markerFont(size: 32.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dependencies: CharactersDependenciesResolver
    private let viewModel: CharactersViewModel
    private var cancellables = [AnyCancellable]()
    
    init(dependencies: CharactersDependenciesResolver) {
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

extension CharactersViewController {}

private extension CharactersViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleImage
        view.addSubview(containerView)
        scrollableStackView.addArrangedSubviews(titleLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.layout {
            $0 -|- (view + 16.0)
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        titleLabel.layout {
            $0.height == 40.0
        }
    }
    
    func bindViewModel() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .idle:
                    break
                case .addCharacters(let characters):
                    print(characters)
                case .showLoading(let show):
                    print(show)
                case .showError(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
}
