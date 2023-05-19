//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import UIKit
import Foundation

final class GetArtists {
    private var appDependencies: AppDependencies
    private var dataRepository: DataRepository
    init(appDependencies: AppDependencies, viewController: ArtistListViewController?) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
    }
    func execute(artistName: String, completion: @escaping (([ArtistEntity]?, WebAPIDataSource.NetworkError?) -> ())) {
        dataRepository.getAllArtists(for: artistName) {(result: Result<ArtistDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                let artistListNoAlbums = iTunesArtistModel.results.map {
                    let id = $0.artistId
                    let name = $0.artistName
                    return ArtistEntity(id: id, name: name)
                }
                completion(artistListNoAlbums, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

