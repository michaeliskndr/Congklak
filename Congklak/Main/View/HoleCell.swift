//
//  HoleCell.swift
//  Congklak
//
//  Created by Michael Iskandar on 22/01/24.
//

import UIKit

class HoleCell: UICollectionViewCell {

    static let reuseIdentifier = "HoleCell"

    let stonesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        addSubview(stonesLabel)
        stonesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stonesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stonesLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    func configure(with stones: Int) {
        stonesLabel.text = "\(stones)"
    }
}
