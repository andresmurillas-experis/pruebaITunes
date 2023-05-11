//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation

protocol ArtistListPresenterProtocol: AnyObject {
    var artistListView: ArtistListViewController? { get set }
    func viewDidLoad()
    func goToDetailViewForArtist(_ artist: ArtistEntity)
}

final class ArtistListPresenter  {
    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?
    private var appDependencies: AppDependenciesResolver
    private var newArtistList: [ArtistEntity] = [ArtistEntity(id: 0, name: "")]
    private var artistDataSource: ArtistDataSource
    private var albumDatasource: AlbumDataSource
    private var artistListNoDiscs: [ArtistEntity] = [ArtistEntity(id: 0, name: "")] {
        didSet {
            addDiscsToArtistIn(artistListNoDiscs)
        }
    }
    private var artistList: [ArtistEntity] = [ArtistEntity(id: 0, name: "ko")] {
        didSet {
            self.artistListView?.setArtistList(artistList)
        }
    }
    private var albumList: [String?]?
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        artistDataSource = appDependencies.resolve()
        albumDatasource = appDependencies.resolve()
    }
}

private extension ArtistListPresenter {
    var coordinator: Coordinator {
        appDependencies.resolve()
    }
}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    func viewDidLoad() {
        guard let artistName = artistListView?.searchText.replacingOccurrences(of: " ", with: "+") else {
            return
        }
        artistDataSource.getAllArtistsFor(artistName: artistName) { [weak self] (result: Result<ArtistDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                self?.artistListNoDiscs = iTunesArtistModel.results.map {
                    let id = $0.artistId
                    let name = $0.artistName
                    return ArtistEntity(id: id, name: name)
                }
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
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListPresenter {
    func addDiscsToArtistIn(_ artistListNoDiscs: [ArtistEntity]) {
        artistList = []
        artistListNoDiscs.map { artist in
            albumList = ["", ""]
            albumDatasource.getTwoAlbumsdFor(artistId: artist.id) { [weak self] (result: Result<AlbumDTO, WebAPIDataSource.NetworkError>) in
                switch result {
                case .success(let iTunesAlbumModel):
                    if (iTunesAlbumModel.results.count > 1) {
                        self?.artistList.append(self?.createArtist(artist: artist, disc1: iTunesAlbumModel.results[1].collectionName, disc2: iTunesAlbumModel.results.last?.collectionName) ?? ArtistEntity(id: 0, name: ""))
                    } else {
                        self?.artistList.append(self?.createArtist(artist: artist, disc1: iTunesAlbumModel.results.first?.collectionName, disc2: iTunesAlbumModel.results.last?.collectionName) ?? ArtistEntity(id: 0, name: ""))
                    }
                case .failure(let error):
                    print(result)
                    switch error {
                    case .serviceError:
                        print("No Data Eroor: ", error)
                    case .noData:
                        print("Network Service Error: ", error)
                    case .parsing:
                        print("JSON Parsing Error: ", error)
                    }
                }
            }
        }
    }
    func createArtist(artist: ArtistEntity, disc1: String?, disc2: String?) -> ArtistEntity {
        var artist = artist
        artist.setDiscNames(discOneName: disc1, discTwoName: disc2)
        return artist
        
    }
}
