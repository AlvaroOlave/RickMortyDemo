//
//  
//  LocationsViewController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL

final class LocationsViewController: UIViewController {
    
    private lazy var titleImage: UIImageView = {
        let image = NavigationTitleIcon()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8.0
        layout.minimumLineSpacing = 8.0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(LocationCollectionViewCell.self,
                            forCellWithReuseIdentifier: "LocationCollectionViewCell")
        collection.register(LocationCollectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "LocationCollectionHeader")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var errorView: ErrorView = {
        let error = ErrorView()
        error.translatesAutoresizingMaskIntoConstraints = false
        error.isHidden = true
        return error
    }()
    
    private let dependencies: LocationsDependenciesResolver
    private let viewModel: LocationsViewModel
    private var cancellables = [AnyCancellable]()
    
    private var locations: [Location] = []
    
    init(dependencies: LocationsDependenciesResolver) {
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

extension LocationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == locations.count - 5 {
            viewModel.loadMoreLocations()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as? LocationCollectionViewCell
        else { return UICollectionViewCell(frame: .zero)}
        cell.setLocation(locations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - padding * 2
        let width = availableWidth / 2
        return CGSize(width: width, height: width * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToLocation(locations[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LocationCollectionHeader", for: indexPath)
            return  header
        }
        return UICollectionReusableView(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}

private extension LocationsViewController {
    func setupView() {
        view.backgroundColor = Colors.rmGreen
        navigationItem.titleView = titleImage
        view.addSubview(collectionView)
        view.addSubview(errorView)
        setupConstraints()
    }
    
    func setupConstraints() {
        collectionView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0 -|- (view + 16.0)
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
                case .addLocations(let locations):
                    self?.setupLocations(locations)
                case .showLoading(let show):
                    self?.showLoadingView(isVisible: show)
                case .showError(let error):
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupLocations(_ locations: [Location]) {
        self.locations.append(contentsOf: locations)
        collectionView.reloadData()
    }
    
    func showError(_ error: Error) {
        collectionView.isHidden = true
        errorView.isHidden = false
        errorView.setErrorDescription(error.localizedDescription)
    }
}

extension LocationsViewController: LoadingCapable {}
