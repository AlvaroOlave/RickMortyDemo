//
//  
//  CharactersListCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//
//

import UIKit
import AutolayoutDSL

final class CharactersListCell: UIView {
    
    private lazy var userIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = Colors.rmPurple
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.rmPurple
        return view
    }()
    
    private lazy var characterIdLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 14.0)
        label.textColor = Colors.rmPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let selectionBlock: (Int) -> Void
    private let id: Int
    
    init(_ id: Int, selectionBlock: @escaping (Int) -> Void) {
        self.selectionBlock = selectionBlock
        self.id = id
        super.init(frame: .zero)
        setupView()
        characterIdLabel.text = "\(id)"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharactersListCell {
    func setupView() {
        backgroundColor = Colors.rmGreen
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.cornerRadius = 4.0
        addSubview(userIcon)
        addSubview(separator)
        addSubview(characterIdLabel)
        addConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(tapped)))
    }
    
    @objc func tapped() {
        selectionBlock(id)
    }
    
    func addConstraints() {
        userIcon.layout {
            ($0.height & $0.width) == (30.0 * 30.0)
            $0.top == topAnchor + 4.0
            $0.centerX == centerXAnchor
            $0.leading == leadingAnchor + 4.0
        }
        separator.layout {
            $0.top == userIcon.bottomAnchor + 4.0
            $0 -|- self
            $0.height == 1.0
        }
        characterIdLabel.layout {
            $0.top == separator.bottomAnchor + 4.0
            $0 -|- self
            $0.bottom == bottomAnchor - 4.0
        }
    }
}
