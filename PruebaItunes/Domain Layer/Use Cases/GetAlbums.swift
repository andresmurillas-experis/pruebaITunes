//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation

final class GetAlbums {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
    }
    func execute(albumId: Int, completion: @escaping (([AlbumEntity]) -> ())) {
        dataRepository.getAllAlbums(for: albumId) { (result: Result<AlbumDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                
                let albumList = iTunesArtistModel.results.suffix(from: 1).map {
                    let name = $0.collectionName
                    let cover = $0.artworkUrl60
                    let coverLarge = $0.artworkUrl100
                    return AlbumEntity(albumName: name, albumCover: cover, albumCoverLarge: coverLarge)
                }
                completion(albumList)
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