//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

protocol OnTapDelegate: AnyObject {
    func didSelectCellWith(artist: ArtistModel)
}
final class ArtistCell: UITableViewCell {

    private var name = UILabel()
    private var discOneName = UILabel()
    private var discTwoName = UILabel()
    private var moreContentExistsIndicator = UILabel()

    private var artist: ArtistModel?
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
        discOneName.text = ""
        discTwoName.text = ""
    }

    @objc func cellTapped() {
        let discOneName = discOneName.text ?? ""
        let discTwoName = discTwoName.text ?? ""
        guard let artist = artist else {
            return
        }
        delegate?.didSelectCellWith(artist: artist)
    }

}

extension ArtistCell {
    func setupViewModel(_ viewModel: ArtistModel) {
        self.name.text = viewModel.name
        self.discOneName.text = viewModel.discOneName
        self.discTwoName.text = viewModel.discTwoName
        moreContentExistsIndicator.isHidden = true
        artist = viewModel
    }

    func viewdidLoad() {
        name.translatesAutoresizingMaskIntoConstraints = false
        discOneName.translatesAutoresizingMaskIntoConstraints = false
        discTwoName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(name)
        self.contentView.addSubview(discOneName)
        self.contentView.addSubview(discTwoName)
        name.contentMode = .scaleAspectFit
        name.clipsToBounds  = true
        discOneName.contentMode = .scaleAspectFit
        discOneName.clipsToBounds  = true
        discTwoName.contentMode = .scaleAspectFit
        discTwoName.clipsToBounds  = true

        self.addConstraint(name.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(name.topAnchor.constraint(equalTo: topAnchor))
        self.addConstraint(name.bottomAnchor.constraint(equalTo: discOneName.topAnchor))
//        self.addConstraint(name.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3))
        self.addConstraint(name.widthAnchor.constraint(equalTo: widthAnchor))
        
        self.addConstraint(discOneName.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(discOneName.topAnchor.constraint(equalTo: name.bottomAnchor))
        self.addConstraint(discOneName.bottomAnchor.constraint(equalTo: discTwoName.topAnchor))
//        self.addConstraint(discOneName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3))
        self.addConstraint(discOneName.widthAnchor.constraint(equalTo: widthAnchor))

        self.addConstraint(discTwoName.leadingAnchor.constraint(equalTo: leadingAnchor))
        self.addConstraint(discTwoName.topAnchor.constraint(equalTo: discOneName.bottomAnchor))
        self.addConstraint(discTwoName.bottomAnchor.constraint(equalTo: bottomAnchor))
//        self.addConstraint(discTwoName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3))
        self.addConstraint(discTwoName.widthAnchor.constraint(equalTo: widthAnchor))
//        self.addConstraint(name.bottomAnchor.constraint(equalTo: bottomAnchor))
//        self.addConstraint(name.trailingAnchor.constraint(equalTo: trailingAnchor))
        
//        print(name.text ?? "")

    }
}
