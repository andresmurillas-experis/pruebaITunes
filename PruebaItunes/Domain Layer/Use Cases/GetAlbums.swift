//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine

final class GetAlbums {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var viewController: ArtistDetailViewController?
    private var cancellables = [AnyCancellable]()
    private var subject: CurrentValueSubject<[AlbumEntity?], WebAPIDataSource.NetworkError>
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
        self.subject = CurrentValueSubject([])
    }
    func execute(albumId: (Int)) -> CurrentValueSubject<[AlbumEntity?], WebAPIDataSource.NetworkError> {
        dataRepository.getAllAlbums(for: albumId).sink(receiveCompletion: { error in
            print(error)
        }, receiveValue: { [weak self] (iTunesAlbumModel) in
            let albumList = iTunesAlbumModel.results.suffix(from: 1).map {
                let name = $0.collectionName
                let cover = $0.artworkUrl60
                let coverLarge = $0.artworkUrl100
                return AlbumEntity(albumName: name, albumCover: cover, albumCoverLarge: coverLarge)
            }
            self?.subject.send(albumList)
        }).store(in: &cancellables)
        return subject
    }
}
