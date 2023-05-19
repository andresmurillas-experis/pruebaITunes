//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation

class GetTwoAlbumNamesUseCase {
    private var appDependencies: AppDependencies
    private var dataRepository: DataRepository
    init(appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        dataRepository = appDependencies.resolve()
    }
    func execute(albumId: Int, completion: @escaping (([AlbumEntity]) -> ())) {
        dataRepository.getTwoAlbums(for: albumId) { (result: Result<AlbumDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                let albumList = iTunesArtistModel.results.map {
                    let name = $0.collectionName
                    let cover = $0.artworkUrl60
                    let coverLarge = $0.artworkUrl100
                    return AlbumEntity(albumName: name, albumCover: cover, albumCoverLarge: coverLarge)
                }
                var safeAlbumList: [AlbumEntity] = []
                for i in 1...2 {
                    if i <= albumList.count - 1{
                        safeAlbumList.append(albumList[i])
                    } else {
                        safeAlbumList.append(AlbumEntity(albumName: nil, albumCover: nil, albumCoverLarge: nil))
                    }
                }
                completion(safeAlbumList)
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
