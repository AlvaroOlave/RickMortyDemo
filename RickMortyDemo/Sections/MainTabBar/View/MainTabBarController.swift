//
//  MainTabBarController.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let dependencies: MainTabBarDependenciesResolver

    init(dependencies: MainTabBarDependenciesResolver) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension MainTabBarController {
    func setupView() {
        setupAppearance()
        
        let characters = dependencies.external.charactersNavigationController()
        let locations = dependencies.external.locationsNavigationController()
        let episodes = dependencies.external.episodesNavigationController()
        
        characters.tabBarItem = tabBarItemFor("person.3.fill", 0)
        locations.tabBarItem = tabBarItemFor("globe", 1)
        episodes.tabBarItem = tabBarItemFor("film", 1)
        
        viewControllers = [characters,
                           locations,
                           episodes]
    }
    
    func setupAppearance() {
        UITabBar.appearance().tintColor = Colors.rmPurple
        UITabBar.appearance().isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.rmGreen
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func tabBarItemFor(_ iconName: String, _ tag: Int) -> UITabBarItem {
        UITabBarItem(title: nil,
                     image: UIImage(systemName: iconName),
                     tag: tag)
    }
}
