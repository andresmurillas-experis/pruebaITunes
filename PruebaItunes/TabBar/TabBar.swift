//
//  TabBar.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/7/23.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
}

fileprivate extension TabBar {
    func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}

extension TabBar {
    func setupVCs() {
        viewControllers = [
            createNavController(for: ArtistListViewController(appDependencies: AppDependencies(navigator: UINavigationController())), title: NSLocalizedString("Search", comment: "Search"), image: UIImage(systemName: "magnifyingglass") ?? UIImage()),
            createNavController(for: SettingsViewController(vm: SettingsViewModel()), title: NSLocalizedString("Settings", comment: "Settings"), image: UIImage(systemName: "gear") ?? UIImage())
        ]
    }
}
