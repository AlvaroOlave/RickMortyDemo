//
//  
//  EpisodesListCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import AutolayoutDSL

final class EpisodesListCell: UIView {
    
    private lazy var cameraIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "film")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = .systemGray6
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var episodeIdLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 14.0)
        label.textColor = .systemGray6
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
        episodeIdLabel.text = "\(id)"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EpisodesListCell {
    func setupView() {
        backgroundColor = Colors.rmBlue
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.cornerRadius = 4.0
        addSubview(cameraIcon)
        addSubview(separator)
        addSubview(episodeIdLabel)
        addConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(tapped)))
    }
    
    @objc func tapped() {
        selectionBlock(id)
    }
    
    func addConstraints() {
        cameraIcon.layout {
            ($0.height & $0.width) == (30.0 * 30.0)
            $0.top == topAnchor + 4.0
            $0.centerX == centerXAnchor
            $0.leading == leadingAnchor + 4.0
        }
        separator.layout {
            $0.top == cameraIcon.bottomAnchor + 4.0
            $0 -|- self
            $0.height == 1.0
        }
        episodeIdLabel.layout {
            $0.top == separator.bottomAnchor + 4.0
            $0 -|- self
            $0.bottom == bottomAnchor - 4.0
        }
    }
}
