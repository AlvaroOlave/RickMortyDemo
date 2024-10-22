//
//  
//  CharactersListView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//
//
import UIKit
import AutolayoutDSL
import Combine

final class CharactersListView: UIView {
    
    private let mainColor: UIColor?
    private let secondaryColor: UIColor?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 24.0)
        label.text = String(localized: "Characters")
        label.textColor = mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.stackView.axis = .horizontal
        view.setSpacing(4.0)
        view.setup(with: self.containerView)
        return view
    }()
    
    @Published var selectedCharacter: Int?
    
    init(mainColor: UIColor? = .systemGray6, secondaryColor: UIColor? = Colors.rmPurple) {
        self.mainColor = mainColor
        self.secondaryColor = secondaryColor
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCharacters(_ ids: [Int]) {
        ids.forEach { id in
            let cell = CharactersListCell(id, selectionBlock: { [weak self] id in
                self?.selectedCharacter = id
            })
            cell.layer.borderColor = secondaryColor?.cgColor
            scrollableStackView.addArrangedSubview(cell)
        }
    }
}

private extension CharactersListView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(containerView)
        addConstraints()
    }
    
    func addConstraints() {
        titleLabel.layout {
            $0.top == topAnchor
            $0.leading == leadingAnchor
        }
        containerView.layout {
            $0.top == titleLabel.bottomAnchor + 4.0
            $0 -|- self
            $0.bottom == bottomAnchor
        }
    }
}
