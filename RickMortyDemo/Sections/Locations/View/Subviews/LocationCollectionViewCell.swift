//
//  LocationCollectionViewCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import UIKit
import AutolayoutDSL

final class LocationCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 12.0)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dimensionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 14.0)
        label.textColor = .systemGray5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLocation(_ location: Location) {
        nameLabel.text = location.name
        typeLabel.text = location.type
        dimensionLabel.text = location.dimension
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        typeLabel.text = ""
        dimensionLabel.text = ""
    }
}

private extension LocationCollectionViewCell {
    func setupView() {
        backgroundColor = Colors.rmBlue
        addSubview(nameLabel)
        addSubview(typeLabel)
        addSubview(dimensionLabel)
        layer.cornerRadius = 8.0
        setupConstraints()
    }
    
    func setupConstraints() {
        nameLabel.layout {
            $0.centerX == centerXAnchor
            $0.top == topAnchor + 8.0
            $0 -|- (self + 4.0)
        }
        typeLabel.layout {
            $0.centerX == centerXAnchor
            $0.top == nameLabel.bottomAnchor + 4.0
            $0 -|- (self + 4.0)
        }
        dimensionLabel.layout {
            $0.centerX == centerXAnchor
            $0.top == typeLabel.bottomAnchor + 8.0
            $0 -|- (self + 4.0)
        }
    }
}
