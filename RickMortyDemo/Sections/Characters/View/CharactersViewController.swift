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
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MainCharacterCell.self, forCellReuseIdentifier: "MainCharacterCell")
        table.register(SideCharactersCell.self, forCellReuseIdentifier: "SideCharactersCell")
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.backgroundColor = .clear
        table.layer.cornerRadius = 8.0
        table.separatorStyle = .none
        table.bounces = false
        return table
    }()
    
    private lazy var titleView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, searchBarCell, filtersView])
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 0,
                                               left: 8.0,
                                               bottom: 0,
                                               right: 8.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Characters")
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
    
    private lazy var filtersView: FiltersView = {
        let view = FiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let error = ErrorView()
        error.translatesAutoresizingMaskIntoConstraints = false
        error.isHidden = true
        return error
    }()
    
    private var searchTerm: String = ""
    
    private let dependencies: CharactersDependenciesResolver
    private let viewModel: CharactersViewModel
    private var cancellables = [AnyCancellable]()
    
    private var characters: [[Character]] = []
    private var filteredCharacters: [[Character]] = []
    
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

private extension CharactersViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleImage
        view.addSubview(tableView)
        view.addSubview(errorView)
        setupConstraints()
        setupFilterButton()
        
        searchBarCell.$searchText
            .sink { [weak self] searchText in
                self?.updateSearchTerm(searchText)
            }.store(in: &cancellables)
        
        filtersView.$selectedStatus
            .dropFirst()
            .sink { [weak self] status in
                print(status)
                self?.viewModel.filterByStatus(status)
            }.store(in: &cancellables)
    }
    
    func setupConstraints() {
        let h = titleLabel.heightAnchor.constraint(equalToConstant: 40.0)
        h.priority = .defaultHigh
        h.isActive = true
        
        let searchHeight = searchBarCell.heightAnchor.constraint(equalToConstant: 40.0)
        searchHeight.priority = .defaultHigh
        searchHeight.isActive = true

        let filterheight = filtersView.heightAnchor.constraint(equalToConstant: 40.0)
        filterheight.priority = .defaultHigh
        filterheight.isActive = true
        
        tableView.layout {
            $0 -|- view
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
        errorView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0 -|- (view + 16.0)
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
        searchBarCell.isHidden.toggle()
        filtersView.isHidden.toggle()
        tableView.reloadRows(at: [], with: .top)
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
                    self?.setupNewCharacter(characters)
                case .showLoading(let show):
                    self?.showLoadingView(isVisible: show)
                case .showError(let error):
                    self?.showError(error)
                case .reset:
                    self?.reset()
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNewCharacter(_ characters: [[Character]]) {
        self.characters.append(contentsOf: characters)
        self.filteredCharacters = filterCharacters(self.characters)
        tableView.reloadData()
    }
    
    func filterCharacters(_ characters: [[Character]]) -> [[Character]] {
        guard !searchTerm.isEmpty else { return characters }
        return characters.compactMap { row in
            let newRow = row.filter( { $0.name.range(of: searchTerm, options: .caseInsensitive) != nil  } )
            return newRow.isEmpty ? nil : newRow
        }
    }
    
    func updateSearchTerm(_ term: String?) {
        guard let term = term else { return }
        searchTerm = term
        filteredCharacters = filterCharacters(characters)
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        guard characters.isEmpty else { return }
        errorView.setErrorDescription(error.localizedDescription)
        tableView.isHidden = true
        errorView.isHidden = false
    }
    
    func reset() {
        characters.removeAll()
        tableView.reloadData()
    }
}

extension CharactersViewController: LoadingCapable {}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = filteredCharacters[indexPath.row]
        
        if row.count == 1, let character = row.first {
            return mainCharacterCell(tableView,
                                     indexPath,
                                     character)
        } else if row.count == 2 {
            return sideCharacterCell(tableView,
                                     indexPath,
                                     row[0],
                                     row[1])
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleView
    }
    
    func mainCharacterCell(_ tableView: UITableView, _ indexPath: IndexPath, _ character: Character) -> UITableViewCell {
        guard let singleCell = tableView.dequeueReusableCell(withIdentifier: "MainCharacterCell", for: indexPath) as? MainCharacterCell
        else { return UITableViewCell(frame: .zero) }
            singleCell.setCharacter(character)
            singleCell.cancellable = singleCell.$selectedCharacter
                .sink { [weak self] character in
                    guard let character = character else { return }
                    self?.viewModel.goToDetail(character)
                }
            return singleCell
    }
    
    func sideCharacterCell(_ tableView: UITableView, _ indexPath: IndexPath, _ left: Character,  _ right: Character) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideCharactersCell", for: indexPath) as? SideCharactersCell
        else { return UITableViewCell(frame: .zero) }
        cell.setCharacters(left, right)
        cell.cancellable = cell.$selectedCharacter
            .sink { [weak self] character in
                guard let character = character else { return }
                self?.viewModel.goToDetail(character)
            }
        return cell
    }
}

extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let limitIndex = filteredCharacters.count - 3
        
        if indexPaths.contains(where: { $0.row >= limitIndex }) {
            viewModel.loadMoreCharacters()
        }
    }
}
