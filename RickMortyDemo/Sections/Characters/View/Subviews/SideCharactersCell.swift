//
//  SideCharactersCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import UIKit
import AutolayoutDSL
import Combine

final class SideCharactersCell: UIView {
    private lazy var leftCharacterCell: CharacterCell = {
        let view = CharacterCell(character: leftCharacter)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectLeft)))
        return view
    }()
    
    private lazy var rightCharacterCell: CharacterCell = {
        let view = CharacterCell(character: rightCharacter)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectRight)))
        return view
    }()
    
    private let leftCharacter: Character
    private let rightCharacter: Character
    
    @Published var selectedCharacter: Character?
    
    init(leftCharacter: Character, rightCharacter: Character) {
        self.leftCharacter = leftCharacter
        self.rightCharacter = rightCharacter
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SideCharactersCell {
    func setupView() {
        addSubview(leftCharacterCell)
        addSubview(rightCharacterCell)
        setupConstraints()
    }
    
    func setupConstraints() {
        leftCharacterCell.layout {
            $0.leading == leadingAnchor
            $0.trailing == centerXAnchor - 4.0
            $0.height == (leftCharacterCell.widthAnchor * 1.5)
            $0 |-| self
        }
        
        rightCharacterCell.layout {
            $0.leading == centerXAnchor + 4.0
            $0.trailing == trailingAnchor
            $0.height == (leftCharacterCell.widthAnchor * 1.5)
            $0 |-| self
        }
    }
    
    @objc func selectLeft() {
        selectedCharacter = leftCharacter
    }
    
    @objc func selectRight() {
        selectedCharacter = rightCharacter
    }
}
