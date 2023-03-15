//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController, ArtistDetailViewProtocol {

    @IBOutlet private var artistNameLabel: UILabel!

    @IBOutlet private weak var collectionView: UICollectionView!

    private var artistDetailPresenter: ArtistDetailPresenterProtocol?

    private var artist: ArtistViewModel?

    private var albumList: [AlbumViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        artistNameLabel.text = artist?.name

        guard let artistId = artist?.id else {
            return
        }

        artistDetailPresenter = ArtistDetailPresenter()
        artistDetailPresenter?.setviewdelegate(artistDetailViewDelegate: self)

        artistDetailPresenter?.download(url: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album")

        setCollectionView()
    }

    func setAlbumList(_ albumList: [AlbumViewModel]) {
        self.albumList = albumList
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

extension ArtistDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
