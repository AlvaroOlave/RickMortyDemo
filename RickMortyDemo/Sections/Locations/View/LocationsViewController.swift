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

final class LocationsViewController: UIViewController {
    
    private let dependencies: LocationsDependenciesResolver
    private let viewModel: LocationsViewModel
    private var cancellables = [AnyCancellable]()
    
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

extension LocationsViewController {}

private extension LocationsViewController {
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
                case .addLocations(let locations):
                    print("LOCATIONS")
                    print(locations)
                case .showLoading(let show):
                    print(show)
                case .showError(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
}
