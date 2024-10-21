//
//  
//  EpisodePopup.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//
//
import UIKit
import AutolayoutDSL
import Combine

final class EpisodePopup: UIView {
    
    private lazy var closeCurtain: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(dismiss)))
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray6
        button.addTarget(self,
                         action: #selector(dismiss),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var onAirLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 14.0)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var charactersListView: CharactersListView = {
        let view = CharactersListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @Published var selectedCharacter: Int?
    
    private var cancellables = [AnyCancellable]()
    
    init(_ episode: Episode) {
        super.init(frame: .zero)
        setupView()
        setupEpisode(episode)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentIn(_ view: UIView) {
        view.addSubview(closeCurtain)
        view.addSubview(self)
        closeCurtain.fill(view)
        self.layout {
            $0 -|- (view + 20.0)
            $0.centerY == view.centerYAnchor
        }
        
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            self.closeCurtain.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}

private extension EpisodePopup {
    func setupView() {
        backgroundColor = Colors.rmPurple
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
        addSubview(titleLabel)
        addSubview(onAirLabel)
        addSubview(charactersListView)
        addSubview(closeButton)
        addConstraints()
        
        charactersListView.$selectedCharacter
            .assign(to: \.selectedCharacter, on: self)
            .store(in: &cancellables)
    }
    
    func addConstraints() {
        closeButton.layout {
            $0.top == topAnchor + 8.0
            $0.trailing == trailingAnchor - 8.0
            ($0.height & $0.width) == (30.0 * 30.0)
        }
        titleLabel.layout {
            $0.top == closeButton.bottomAnchor + 4.0
            $0 -|- self
        }
        onAirLabel.layout {
            $0.top == titleLabel.bottomAnchor + 4.0
            $0 -|- self
        }
        charactersListView.layout {
            $0.top == onAirLabel.bottomAnchor + 4.0
            $0 -|- (self + 8.0)
            $0.bottom == bottomAnchor - 8.0
        }
    }
    
    func setupEpisode(_ episode: Episode) {
        titleLabel.text = "\(episode.episode): \(episode.name)"
        onAirLabel.text = episode.air_date
        charactersListView.setupCharacters(episode.characters.map({ idFromURL($0)}).compactMap({ $0 }))
    }
    
    func idFromURL(_ url: String) -> Int? {
        guard let id = url
            .components(separatedBy: "/")
            .last
        else { return nil }
        return Int(id)
    }
}
