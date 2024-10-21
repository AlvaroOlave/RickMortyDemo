//
//  OriginView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import UIKit
import AutolayoutDSL

final class OriginView: UIView {

    private lazy var originLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var goToLocationIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = Colors.rmBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOrigin(_ originName: String) {
        originLabel.text = originName
    }
}

private extension OriginView {
    func setupView() {
        addSubview(originLabel)
        addSubview(goToLocationIcon)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        originLabel.layout {
            $0.leading == leadingAnchor
            $0.trailing == goToLocationIcon.leadingAnchor - 4.0
            $0.centerY == centerYAnchor
            $0 |-| self
        }
        goToLocationIcon.layout {
            $0.trailing == trailingAnchor
            $0.centerY == centerYAnchor
            ($0.height & $0.width) == (24.0 * 24.0)
        }
    }
}
