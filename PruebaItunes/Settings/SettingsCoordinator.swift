//
//  SettingsCoordinator.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 18/7/23.
//

import Foundation
import UIKit

class SettingsCoordinator {
    private var appDependencies: AppDependencies
    private var nav: UINavigationController
    init(_ appDependencies: AppDependencies, navigationController nav: UINavigationController) {
        self.appDependencies = appDependencies
        self.nav = nav
    }
    func start() -> UINavigationController {
        let vm: SettingsViewModel = appDependencies.resolve()
        let settingsviewController = SettingsViewController(vm: vm)
        nav.navigationController?.navigationBar.isHidden = true
        nav.tabBarItem.image = UIImage(systemName: "gear") ?? UIImage()
        nav.pushViewController(settingsviewController, animated: true)
        return nav
    }
}
