//
//  EpisodeTableViewCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import UIKit
import AutolayoutDSL

final class EpisodeTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 20.0)
        label.textColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var onAirLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.markerFont(size: 14.0)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var goToDetailIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = .systemGray6
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setEpisode(_ episode: Episode) {
        titleLabel.text = "\(episode.episode): \(episode.name)"
        onAirLabel.text = episode.air_date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        onAirLabel.text = ""
    }
}

private extension EpisodeTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = Colors.rmPurple?.withAlphaComponent(0.8)
        addSubview(titleLabel)
        addSubview(onAirLabel)
        addSubview(goToDetailIcon)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.layout {
            $0.top == topAnchor + 16.0
            $0.leading == leadingAnchor + 16.0
            $0.trailing == goToDetailIcon.leadingAnchor - 8.0
        }
        onAirLabel.layout {
            $0.top == titleLabel.bottomAnchor + 8.0
            $0.leading == leadingAnchor + 16.0
            $0.trailing == goToDetailIcon.leadingAnchor - 8.0
            $0.bottom == bottomAnchor - 16.0
        }
        
        goToDetailIcon.layout {
            $0.trailing == trailingAnchor - 16.0
            ($0.height & $0.width) == (24.0 * 24.0)
            $0.centerY == centerYAnchor
        }
    }
}
