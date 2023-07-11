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
        view.backgroundColor = .systemRed
        UITabBar.appearance().barTintColor = .systemRed
        tabBar.tintColor = .label
        setupVCs()
    }
}

extension TabBar {
    func setupVCs() {
        viewControllers = [createNavController(for: ArtistListViewController(appDependencies: AppDependencies(navigator: UINavigationController())), title: NSLocalizedString("", comment: ""), image: UIImage(systemName: "home") ?? UIImage()   )]
    }
}

fileprivate extension TabBar {
    func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        UITabBar.appearance().barTintColor = .systemBackground
        setupVCs()
        return navController
    }
}
