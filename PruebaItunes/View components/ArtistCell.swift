//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit
import Domain

protocol OnTapDelegate: AnyObject {
    func didSelectCellWith(artist: ArtistEntity)
}

final class ArtistCell: UITableViewCell {
    private var name = UILabel()
    private let discografia = UILabel()
    private var discOneName = UILabel()
    private var discTwoName = UILabel()
    private var moreContentExistsIndicator = UILabel()
    private var artist: ArtistEntity?
    weak var delegate: OnTapDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        addGestureRecognizer(tapGestureRecognizer)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        name.text = ""
        discografia.text = "Discografia"
        discOneName.text = ""
        discTwoName.text = ""
    }
    @objc func cellTapped() {
        guard let artist = artist else {
            return
        }
        delegate?.didSelectCellWith(artist: artist)
    }
}

extension ArtistCell {
    func setupViewModel(_ viewModel: ArtistEntity) {
        name.text = viewModel.name
        discOneName.text = viewModel.discOneName
        discTwoName.text = viewModel.discTwoName
        moreContentExistsIndicator.isHidden = true
        artist = viewModel
    }
    func viewdidLoad() {
        name.translatesAutoresizingMaskIntoConstraints = false
        discografia.translatesAutoresizingMaskIntoConstraints = false
        discOneName.translatesAutoresizingMaskIntoConstraints = false
        discTwoName.translatesAutoresizingMaskIntoConstraints = false
        discografia.text = "Discografia"

        self.contentView.addSubview(name)
        self.contentView.addSubview(discografia)
        self.contentView.addSubview(discOneName)
        self.contentView.addSubview(discTwoName)

        self.addConstraint(name.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(name.topAnchor.constraint(equalTo: topAnchor))
        self.addConstraint(name.widthAnchor.constraint(equalTo: widthAnchor))
        self.addConstraint(name.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2))
        name.contentMode = .scaleToFill

        self.addConstraint(discografia.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(discografia.topAnchor.constraint(equalTo: name.bottomAnchor))
        self.addConstraint(discografia.widthAnchor.constraint(equalTo: widthAnchor))
        self.addConstraint(discografia.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2))
        discografia.contentMode = .scaleToFill

        self.addConstraint(discOneName.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(discOneName.topAnchor.constraint(equalTo: discografia.bottomAnchor))
        self.addConstraint(discOneName.widthAnchor.constraint(equalTo: widthAnchor))
        self.addConstraint(discOneName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2))
        discOneName.contentMode = .scaleToFill

        self.addConstraint(discTwoName.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(discTwoName.topAnchor.constraint(equalTo: discOneName.bottomAnchor))
        self.addConstraint(discTwoName.widthAnchor.constraint(equalTo: widthAnchor))
        self.addConstraint(discTwoName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2))
        discTwoName.contentMode = .scaleToFill
    }
}
