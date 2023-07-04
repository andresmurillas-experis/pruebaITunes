//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation
import Combine
import UIKit
import Domain
import WidgetKit

public final class ArtistListViewModel {
    var cancellables = [AnyCancellable]()
    var subject: CurrentValueSubject<[ArtistEntity], Error>
    var passSub = PassthroughSubject<String, Never>()
    var coordinator: ArtistListCoordinator
    private var artistList: [ArtistEntity] = [] {
        didSet {
            subject.send(artistList)
        }
    }
    private var albumNameList: [String] = []
    init(appDependencies: AppDependencies) {
        subject = CurrentValueSubject(artistList)
        coordinator = appDependencies.resolve()
    }
}

extension ArtistListViewModel {
    func viewDidLoad() {
        bindSubjects()
    }
    func renewSearch(for searchText: String) {
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        artistList = []
        GetArtists.execute(artistName: artistName)
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
    func getArtisPublisher(_ searchText: String) -> AnyPublisher<[ArtistEntity], NetworkError> {
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        return GetArtists.execute(artistName: artistName)
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListViewModel {
    func addDiscsToArtistsIn(_ artists: [ArtistEntity]) {
        artists.forEach { [unowned self] artist in
            GetTwoAlbumNames.execute(albumId: artist.id).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] (albumNames) in
                var names: [String] = albumNames
                for _ in albumNames.count ... 5 {
                    names.append("")
                }
                print(albumNames, "/\n", names)
                self?.artistList.append(ArtistEntity(id: artist.id, name: artist.name, discOneName: names[0], discTwoName: names[1]))
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
