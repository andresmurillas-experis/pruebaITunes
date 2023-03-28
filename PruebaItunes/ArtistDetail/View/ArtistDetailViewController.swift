//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

protocol ArtistDetailViewProtocol: AnyObject {
    func setAlbumList(_ albumList: [AlbumViewModel])
}

final class ArtistDetailViewController: UIViewController {

    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let presenter: ArtistDetailPresenterProtocol = ArtistDetailPresenter()
    private var albumList: [AlbumViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, artist: ArtistViewModel) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter.setArtist(artist)
        presenter.artistDetailView = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setCollectionView()
    }
    
    func setAppDependencies(_ appDependencies: AppDependenciesResolver?) {
        self.presenter.appDependencies = appDependencies
    }

}

private extension ArtistDetailViewController {
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumView", bundle: nil), forCellWithReuseIdentifier: "AlbumCellReuseIdentifier")
    }
}

extension ArtistDetailViewController: ArtistDetailViewProtocol {
    func setAlbumList(_ albumList: [AlbumViewModel]) {
        self.albumList = albumList
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
