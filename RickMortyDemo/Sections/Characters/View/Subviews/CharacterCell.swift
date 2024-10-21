//
//  CharacterCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation
import UIKit
import AutolayoutDSL

class CharacterCell: UIView {
    
    private lazy var placeholder: UIImage? = {
        UIImage(named: "rmPlaceholder")
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView(image: placeholder)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var nameFrame: GradientView = {
        let view = GradientView(gradient: gradient)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.addSublayer(gradient)
        return view
    }()
    
    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                (Colors.rmBlue ?? .black).cgColor,
                                (Colors.rmBlue ?? .black).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.1, 1.0]
        return gradientLayer
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var statusIcons: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var genderIcon: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var aliveIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circle.circle.fill")?.withRenderingMode(.alwaysTemplate))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    init(character: Character) {
        super.init(frame: .zero)
        setupView()
        setupCharacter(character)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharacterCell {
    func setupView() {
        addSubview(image)
        image.addSubview(nameFrame)
        nameFrame.addSubview(nameLabel)
        nameFrame.addSubview(statusIcons)
        statusIcons.addSubview(genderIcon)
        statusIcons.addSubview(aliveIcon)
        addConstraints()
    }
    
    func addConstraints() {
        image.fill(self)
        nameFrame.layout {
            $0 -|- self
            $0.bottom == bottomAnchor
        }
        nameLabel.layout {
            $0 |-| (nameFrame + 16)
            $0.leading == nameFrame.leadingAnchor + 16.0
            $0.trailing == statusIcons.leadingAnchor - 4.0
        }
        
        statusIcons.layout {
            $0.centerY == nameFrame.centerYAnchor
            $0.height == 20.0
            $0.width == 40.0
            $0.trailing == nameFrame.trailingAnchor - 8.0
        }
        
        aliveIcon.layout {
            $0.leading == statusIcons.leadingAnchor
            $0 |-| statusIcons
            $0.trailing == statusIcons.centerXAnchor
        }
        
        genderIcon.layout {
            $0.leading == statusIcons.centerXAnchor
            $0 |-| statusIcons
            $0.trailing == statusIcons.trailingAnchor
        }
    }
    
    func setupCharacter(_ character: Character) {
        if let url = URL(string: character.image) {
            ImageLoader.shared.loadImage(from: url,
                                         placeholder: placeholder) { [weak self] img in
                self?.image.image = img
            }
        }
        nameLabel.text = character.name
        
        genderIcon.text = character.gender.icon()
        switch character.status {
        case .Alive:
            aliveIcon.tintColor = .green.withAlphaComponent(0.8)
        case .Dead:
            aliveIcon.tintColor = .red.withAlphaComponent(0.8)
        case .unknown:
            aliveIcon.tintColor = .gray.withAlphaComponent(0.8)
        }
    }
}
