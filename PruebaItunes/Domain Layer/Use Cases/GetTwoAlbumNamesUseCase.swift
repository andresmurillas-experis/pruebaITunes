//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine

class GetTwoAlbumNamesUseCase {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var cancellables = [AnyCancellable]()
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        dataRepository = appDependencies.resolve()
    }
    func execute(albumId: Int, completion: @escaping (([AlbumEntity]) -> ())) {
        dataRepository.getTwoAlbums(for: albumId).sink(receiveCompletion: { error in
            print(error)
        }, receiveValue: { iTunesAlbums in
                let albumList = iTunesAlbums.results.map {
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
        }).store(in: &cancellables)
    }
}
