//
//  SettingsViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 18/7/23.
//

import Foundation
import UIKit

public final class SettingsViewModel {
    private let vm: SettingsViewModel
    init(_ appDependencies: AppDependencies) {
        vm = appDependencies.resolve()
    }
}
