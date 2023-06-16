//
//  ArtistListViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit
import Combine
import Domain

protocol ArtistListViewProtocol: AnyObject {
    func setArtistList(_ artistList: [ArtistEntity])
}

final class ArtistListViewController: UIViewController, AlertPrompt {
    private let tableView = UITableView()
    private var searchBar: UISearchBar = UISearchBar()
    private var vm: ArtistListViewModel
    private var cancellables = [AnyCancellable]()
    var searchText = ""
    private var artistList: [ArtistEntity]? = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    private var error: NetworkError? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                switch self?.error {
                case .parsing:
                    self?.showError(self?.error, title: "Parsing Error")
                    return
                case .noData:
                    self?.showError(self?.error, title: "No Data Error")
                    return
                case .serviceError:
                    self?.showError(self?.error, title: "Service Error")
                    return
                case .alamofire:
                    self?.showError(self?.error, title: "Alamofire Error")
                    return
                case .none:
                    return
                }
            }
        }
    }
    init(appDependencies: AppDependenciesResolver) {
        self.vm = appDependencies.resolve()
        super.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        setupTableView()
        vm.subject
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .finished:
                    print("finished succesfully")
                case .failure(let error):
                    self?.error = error as! NetworkError
                    self?.reloadInputViews()
                }
            }, receiveValue: { artistList in
                self.artistList = artistList
            })
            .store(in: &cancellables)
        vm.viewDidLoad()
    }
}

private extension ArtistListViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(ArtistCell.self, forCellReuseIdentifier:"ArtistCellReuseIdentifier")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ArtistListViewController: ArtistListViewProtocol {
    func setArtistList(_ artistList: [ArtistEntity]) {
        self.artistList = artistList
    }
}

extension ArtistListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.renewSearch(for: searchText)
        vm.passSub.send(searchText)
    }
}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellReuseIdentifier", for: indexPath) as? ArtistCell else {
            return UITableViewCell()
        }
        guard let artistList = artistList else {
            return cell
        }
        if indexPath.item < artistList.count {
            let artist = artistList[indexPath.item]
            cell.setupViewModel(artist)
            cell.viewdidLoad()
            cell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ArtistListViewController: OnTapDelegate {
    func didSelectCellWith(artist: ArtistEntity) {
        vm.goToDetailViewForArtist(artist)
    }
}
