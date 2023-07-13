//
//  SettingsviewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 13/7/23.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private var vm: SettingsViewModel
    init(vm: SettingsViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
