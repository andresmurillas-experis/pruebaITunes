//
//  ArtistListViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

protocol ArtistListViewProtocol: AnyObject {
    func setArtistList(_ artistList: [ArtistViewModel])
}

final class ArtistListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var presenter: ArtistListPresenterProtocol?
    private var artistList: [ArtistViewModel] = [] {
        didSet {
            self.tableView.reloadData()
            print("spear")
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setTableView()
    }

    func setPresenter(_ presenter: ArtistListPresenterProtocol) {
        self.presenter = presenter
        presenter.artistListView = self
    }

}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellReuseIdentifier", for: indexPath) as? ArtistViewCell else {
            return UITableViewCell()
        }
        let artist = artistList[indexPath.item]
        cell.setupViewModel(artist)
        cell.delegate = self
        return cell
    }

}

extension ArtistListViewController: ArtistListViewProtocol {
    func setArtistList(_ artistList: [ArtistViewModel]) {
        self.artistList = artistList
    }
}

private extension ArtistListViewController {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ArtistView", bundle: nil), forCellReuseIdentifier: "ArtistCellReuseIdentifier")
    }
}

extension ArtistListViewController: OnTapDelegate {
    func didSelectCellWith(artist: ArtistViewModel) {
        presenter?.goToDetailViewForArtist(artist)
    }
}
