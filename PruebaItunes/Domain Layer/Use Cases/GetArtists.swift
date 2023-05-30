//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import UIKit
import Foundation
import Combine

final class GetArtists {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var subject: CurrentValueSubject<[ArtistEntity?], WebAPIDataSource.NetworkError>
    private var cancellables = [AnyCancellable]()
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
        self.subject = CurrentValueSubject([])
    }
    func execute(artistName: String) -> CurrentValueSubject<[ArtistEntity?], WebAPIDataSource.NetworkError> {
        dataRepository.getAllArtists(for: artistName).sink(receiveCompletion: { (error) in
        }, receiveValue: { [weak self] (iTunesArtists) in
            let artistListNoAlbums = iTunesArtists.results.map {
                let id = $0.artistId
                let name = $0.artistName
                return ArtistEntity(id: id, name: name)
            }
            self?.subject.send(artistListNoAlbums as [ArtistEntity])
        }).store(in: &cancellables)
        return subject
    }
}
