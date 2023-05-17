//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import Foundation

final class GetArtists {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
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
                    print(error)
                    print("No Data Eroor: ", error)
                case .noData:
                    print(error)
                    print("Network Service Error: ", error)
                case .parsing:
                    print(error)
                    print("JSON Parsing Error: ", error)
                }
            }
        }
    }
}

