//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import UIKit
import Foundation

final class GetArtists {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var viewController: ArtistListViewController?
    init(appDependencies: AppDependenciesResolver, viewController: ArtistListViewController?) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
        self.viewController = viewController
    }
    func execute(artistName: String, completion: @escaping (([ArtistEntity]) -> ())) {
        dataRepository.getAllArtists(for: artistName) {(result: Result<ArtistDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                let artistListNoAlbums = iTunesArtistModel.results.map {
                    let id = $0.artistId
                    let name = $0.artistName
                    return ArtistEntity(id: id, name: name)
                }
                completion(artistListNoAlbums)
            case .failure(let error):
                switch error {
                case .serviceError:
                    DispatchQueue.main.async {
                        self.viewController?.showError(error, title: "Service Error")
                    }
                case .noData:
                    DispatchQueue.main.async {
                        self.viewController?.showError(error, title: "No Data Error")
                    }
                case .parsing:
                    DispatchQueue.main.async {
                        self.viewController?.showError(error, title: "Parsing Error")
                    }
                }
            }
        }
    }
}

