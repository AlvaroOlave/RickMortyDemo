//
//  SideCharactersCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import UIKit
import AutolayoutDSL
import Combine

final class SideCharactersCell: UITableViewCell {
    private lazy var leftCharacterCell: CharacterCell = {
        let view = CharacterCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectLeft)))
        return view
    }()
    
    private lazy var rightCharacterCell: CharacterCell = {
        let view = CharacterCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectRight)))
        return view
    }()
    
    private var leftCharacter: Character?
    private var rightCharacter: Character?
    
    @Published var selectedCharacter: Character?
    var cancellable: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        cancellable = nil
        selectedCharacter = nil
        leftCharacter = nil
        rightCharacter = nil
        leftCharacterCell.prepareForReuse()
        rightCharacterCell.prepareForReuse()
    }
    
    func setCharacters(_ left: Character, _ right: Character) {
        self.leftCharacter = left
        self.rightCharacter = right
        leftCharacterCell.setCharacter(left)
        rightCharacterCell.setCharacter(right)
    }
}

private extension SideCharactersCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(leftCharacterCell)
        contentView.addSubview(rightCharacterCell)
        setupConstraints()
    }
    
    func setupConstraints() {
        leftCharacterCell.layout {
            $0.leading == contentView.leadingAnchor
            $0.trailing == contentView.centerXAnchor - 4.0
            $0.height == (leftCharacterCell.widthAnchor * 1.5) ~ .defaultHigh
            $0 |-| (contentView + 4.0)
        }
        
        rightCharacterCell.layout {
            $0.leading == contentView.centerXAnchor + 4.0
            $0.trailing == contentView.trailingAnchor
            $0.height == (leftCharacterCell.widthAnchor * 1.5) ~ .defaultHigh
            $0 |-| (contentView + 4.0)
        }
    }
    
    @objc func selectLeft() {
        selectedCharacter = leftCharacter
    }
    
    @objc func selectRight() {
        selectedCharacter = rightCharacter
    }
}
