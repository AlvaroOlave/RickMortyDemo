//
//  
//  EpisodesListView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import AutolayoutDSL
import Combine

final class EpisodesListView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 24.0)
        label.text = "Episodes"
        label.textColor = Colors.rmBlue
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
    
    @Published var selectedEpisode: Int?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEpisodes(_ ids: [Int]) {
        ids.forEach { id in
            scrollableStackView.addArrangedSubview(EpisodesListCell(id, selectionBlock: { [weak self] id in
                self?.selectedEpisode = id
            }))
        }
    }
}

private extension EpisodesListView {
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
