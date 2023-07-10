//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation
import Combine
import Domain
import WidgetKit

public final class ArtistDetailViewModel {
    var dataTask: URLSessionDataTask?
    public var subject: CurrentValueSubject<[AlbumEntity], Error>
    private var cancellables = [AnyCancellable]()
    private var artist: ArtistEntity?
    private var passSub = PassthroughSubject<Int, Never>()
    private var lastAlbum: AlbumEntity?
    public init() {
        self.subject = CurrentValueSubject<[AlbumEntity], Error>([])
    }
}

extension ArtistDetailViewModel {
    
    public func setArtist(_ artist: ArtistEntity) {
        self.artist = artist
    }
    public func viewDidLoad() {
        guard let artistId = artist?.id else {
            return
        }
        GetAlbums
            .execute(albumId: artistId).subscribe(on: DispatchQueue.global(qos: .background)).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("GetAlbums finished succesfully")
                case .failure:
                    print("Encountered error")
                    return
                }
            }, receiveValue: { [weak self] (albums) in
                var albumList: [AlbumEntity] = albums
                albumList.removeFirst()
                self?.subject.send(albumList)
                guard let urlString = albumList.last?.coverLarge else {
                    return
                }
                guard let url = URL(string: urlString) else {
                    return
                }
                let request = URLRequest(url: url)
                let session = URLSession.shared
                session.dataTask(with: request) { data, response, error in
                    if error != nil {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    UserDefaults(suiteName: "group.com.PruebaItunes")?.set(data, forKey: "album")
                    WidgetCenter.shared.reloadAllTimelines()
                }.resume()
            }).store(in: &cancellables)
    }
}

private extension ArtistDetailViewModel {
    func bindSubjects() {
        if #available(iOS 14.0, *) {
            self.passSub.flatMap { albumId in
                return GetAlbums.execute(albumId: albumId)
            }.sink { completion in
                if case .failure = completion {
                    self.bindSubjects()
                }
            } receiveValue: { albums in
                self.subject.send(albums)
            }.store(in: &cancellables)
        } else {
            // Fallback on earlier versions
        }
    }
}
