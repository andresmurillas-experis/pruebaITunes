//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController, ArtistDetailViewDelegate{

    @IBOutlet private var artistNameLabel: UILabel!

    @IBOutlet private weak var collectionView: UICollectionView!

    private let artistDetailPresenter = ArtistDetailPresenter()

    private var artist: ArtistViewModel?

    private var albumList: [AlbumViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        artistDetailPresenter.setviewdelegate(artistDetailViewDelegate: self)
        artistNameLabel.text = artist?.name
        
        guard let artistId = artist?.id else {
            return
        }

        artistDetailPresenter.download(from: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album") { [weak self] result in
            switch result {
            case .success(let albumList):
                self?.albumList = albumList
            case .failure(let error):
                switch error {
                case .noData:
                    print("Error: Network Service Error: ", error)
                case .serviceError:
                    print("Error: No Data Eroor: ", error)
                case .parsing:
                    print("Error: JSON Parsong Error: ", error)
                }
            }
        }
        setCollectionView()
    }

    func setArtist(_ artist: ArtistViewModel) {
        self.artist = artist
    }

}

extension ArtistDetailViewController {

    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumView", bundle: nil), forCellWithReuseIdentifier: "AlbumCellReuseIdentifier")
    }

}

extension ArtistDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCellReuseIdentifier", for: indexPath) as? AlbumViewCell else {
            return UICollectionViewCell()
        }
        cell.setupViewModel(albumList[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 175)
    }

}
