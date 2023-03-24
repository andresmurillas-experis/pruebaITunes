//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import Foundation

protocol AppDependenciesResolver {
    func resolve() -> DownloadClient
}

class AppDependencies: AppDependenciesResolver {
    func resolve() -> DownloadClient {
        return DownloadClient()
    }
}
