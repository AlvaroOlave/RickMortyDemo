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
        let image = NavigationTitleIcon()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.setSpacing(8.0)
        view.setup(with: self.containerView)
        view.setScrollDelegate(self)
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
    
    private lazy var searchBarCell: SearchBarCell = {
        let view = SearchBarCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let error = ErrorView()
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()
    
    private var searchTerm: String = ""
    
    private let dependencies: CharactersDependenciesResolver
    private let viewModel: CharactersViewModel
    private var cancellables = [AnyCancellable]()
    
    private var characters: [[Character]] = []
    
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

extension CharactersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollheight = scrollView.frame.size.height
        
        if offset > contentHeight - scrollheight * 2 {
            viewModel.loadMoreCharacters()
        }
    }
}

private extension CharactersViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleImage
        view.addSubview(containerView)
        scrollableStackView.addArrangedSubviews(titleLabel)
        scrollableStackView.addArrangedSubviews(searchBarCell)
        setupConstraints()
        setupFilterButton()
        
        searchBarCell.$searchText
            .sink { [weak self] searchText in
                self?.updateSearchTerm(searchText)
            }.store(in: &cancellables)
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
    
    func setupFilterButton() {
        let filterButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle")?.withRenderingMode(.alwaysTemplate),
                                                style: .plain,
                                                target: self,
                                                action: #selector(showFilter))
        filterButtonItem.tintColor = Colors.rmBlue
        
        navigationItem.setRightBarButton(filterButtonItem, animated: false)
    }
    
    @objc func showFilter() {
        UIView.animate(withDuration: 0.2) {
            self.searchBarCell.isHidden.toggle()
            self.scrollableStackView.stackView.layoutIfNeeded()
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
                case .addCharacters(let characters):
                    self?.setupNewCharacterViews(characters)
                case .showLoading(let show):
                    self?.showLoadingView(isVisible: show)
                case .showError(let error):
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNewCharacterViews(_ characters: [[Character]]) {
        self.characters.append(contentsOf: characters)
        createView()
    }
    
    func createView() {
        filteredCharacters(characters).forEach { row in
            if row.count == 1, let character = row.first {
                let singleCell = MainCharacterCell(character: character)
                singleCell.$selectedCharacter
                    .sink { [weak self] character in
                        guard let character = character else { return }
                        self?.viewModel.goToDetail(character)
                    }
                    .store(in: &cancellables)
                scrollableStackView.addArrangedSubviews(singleCell)
            } else if row.count == 2 {
                let cell = SideCharactersCell(leftCharacter: row[0], rightCharacter: row[1])
                cell.$selectedCharacter
                    .sink { [weak self] character in
                        guard let character = character else { return }
                        self?.viewModel.goToDetail(character)
                    }
                    .store(in: &cancellables)
                scrollableStackView.addArrangedSubviews(cell)
            }
        }
    }
    
    func filteredCharacters(_ characters: [[Character]]) -> [[Character]] {
        guard !searchTerm.isEmpty else { return characters }
        return characters.compactMap { row in
            let newRow = row.filter( { $0.name.range(of: searchTerm, options: .caseInsensitive) != nil  } )
            return newRow.isEmpty ? nil : newRow
        }
    }
    
    func updateSearchTerm(_ term: String?) {
        guard let term = term else { return }
        print(term)
        scrollableStackView.removeAll(ofType: MainCharacterCell.self)
        scrollableStackView.removeAll(ofType: SideCharactersCell.self)
        searchTerm = term
        createView()
    }
    
    func showError(_ error: Error) {
        guard characters.isEmpty else { return }
        errorView.setErrorDescription(error.localizedDescription)
        scrollableStackView.addArrangedSubviews(errorView)
    }
}

extension CharactersViewController: LoadingCapable {}
