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
    var passSub = PassthroughSubject<String, Never>()
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
    func viewDidLoad() {
        bindSubjects()
    }
    func renewSearch(for searchText: String) {
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        artistList = []
        let getArtists: GetArtists = appDependencies.resolve()
        getArtists.execute(artistName: artistName)
            .subscribe(on: DispatchQueue.global()).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion{
                case .finished:
                    print("GetAlbums finished succesfully")
                case .failure:
                    print("Encountered error")
                    return
                }
            }, receiveValue: { [weak self] (artists) in
                var albumList: [ArtistEntity] = artists
                if !albumList.isEmpty {
                    albumList.removeFirst()
                }
                self?.subject.send(albumList)
            }).store(in: &cancellables)
    }
    func getArtisPublisher(_ searchText: String) -> AnyPublisher<[ArtistEntity], WebAPIDataSource.NetworkError> {
        let getArtists: GetArtists = appDependencies.resolve()
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        return getArtists.execute(artistName: artistName)
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListViewModel {
    func addDiscsToArtistsIn(_ artists: [ArtistEntity]) {
        let getTwoAlbumNames: GetTwoAlbumNamesUseCase = appDependencies.resolve()
        artists.forEach { [unowned self] artist in
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
    func bindSubjects() {
        passSub.flatMap { [unowned self] name in
            self.getArtisPublisher(name)
        }.sink { completion in
            if case .failure = completion {
                self.bindSubjects()
            }
        } receiveValue: { artists in
            self.addDiscsToArtistsIn(artists)
        }.store(in: &cancellables)
    }
}
