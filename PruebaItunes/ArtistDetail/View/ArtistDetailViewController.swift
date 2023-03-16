//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

protocol ArtistDetailViewProtocol: AnyObject {

    func setAlbumList(_ albumList: [AlbumViewModel])

//    var presenter: ArtistDetailPresenterProtocol? {get set}
}

final class ArtistDetailViewController: UIViewController, ArtistDetailViewProtocol {

    @IBOutlet private var artistNameLabel: UILabel!

    @IBOutlet private weak var collectionView: UICollectionView!

    private var artist: ArtistViewModel?
    
    private var presenter: ArtistDetailPresenterProtocol?

    private var albumList: [AlbumViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter = ArtistDetailPresenter()
        presenter?.artistDetailView = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        guard let artist = self.artist else {
            return
        }
        setCollectionView()
        presenter?.setArtist(artist)
        presenter?.setViewDelegate(artistDetailView: self)
        presenter?.viewDidLoad()
    }

    func setAlbumList(_ albumList: [AlbumViewModel]) {
        self.albumList = albumList
    }

    func setArtist(_ artist: ArtistViewModel) {
        self.artist = artist
        print(artist)
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
