//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation
import Combine

final class ArtistListViewModel {
    private var appDependencies: AppDependenciesResolver
    private var cancellables = [AnyCancellable]()
    var subject: CurrentValueSubject<[ArtistEntity], WebAPIDataSource.NetworkError>
    private var searchText = ""
    private var artistList: [ArtistEntity] = [] {
        didSet {
            subject.send(artistList)
        }
    }
    private var albumNameList: [String] = []
    init(appDependencies: AppDependenciesResolver) {
        subject = CurrentValueSubject(artistList)
        self.appDependencies = appDependencies
    }
}

private extension ArtistListViewModel {
    var coordinator: ArtistListCoordinator {
        appDependencies.resolve()
    }
}

extension ArtistListViewModel {
    func setPassThroughSubject(subject: PassthroughSubject<String, WebAPIDataSource.NetworkError>) {
        subject.sink { completion in
        } receiveValue: { [weak self] (value) in
            self?.searchText = value
        }.store(in: &cancellables)
    }
    
    func renewSearch() {
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        artistList = []
        let getArtists: GetArtists = appDependencies.resolve()
        getArtists.execute(artistName: artistName).sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                print("🚠")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] artists in
            self?.addDiscsToArtistsIn(artists)
        }).store(in: &cancellables)
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListViewModel {
    func addDiscsToArtistsIn(_ artists: [ArtistEntity]) {
        let getTwoAlbumNames: GetTwoAlbumNamesUseCase = appDependencies.resolve()
        artists.forEach { artist in
            getTwoAlbumNames.execute(albumId: artist.id).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] (albumNames) in
                self?.artistList.append(ArtistEntity(id: artist.id, name: artist.name, discOneName: albumNames[0], discTwoName: albumNames[1]))
            }).store(in: &cancellables)
            return
        }
    }
}
