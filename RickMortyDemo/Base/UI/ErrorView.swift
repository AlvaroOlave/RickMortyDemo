//
//  
//  ErrorView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//
//
import UIKit
import AutolayoutDSL

final class ErrorView: UIView {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.backgroundColor = UIColor.systemGray3
        
        return view
    }()
    
    private lazy var errorIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = .systemGray6
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorDescription(_ description: String) {
        descriptionLabel.text = description
    }
}

private extension ErrorView {
    func setupView() {
        addSubview(container)
        container.addSubview(errorIcon)
        container.addSubview(descriptionLabel)
        addConstraints()
    }
    
    func addConstraints() {
        container.layout {
            $0 -|- (self + 16.0)
            $0 |-| self
        }
        errorIcon.layout {
            $0.top == container.topAnchor + 12.0
            ($0.height & $0.width) == (48 * 48.0)
            $0.centerX == container.centerXAnchor
        }
        descriptionLabel.layout {
            $0.top == errorIcon.bottomAnchor + 12.0
            $0 -|- (self + 16.0)
            $0.bottom == container.bottomAnchor - 12.0
        }
    }
}
