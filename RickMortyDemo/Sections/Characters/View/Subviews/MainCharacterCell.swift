//
//  
//  MainCharacterCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL

final class MainCharacterCell: UITableViewCell {
    
    private lazy var characterCell: CharacterCell = {
        let view = CharacterCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectCharacter)))
        return view
    }()
    
    @Published var selectedCharacter: Character?
    var cancellable: AnyCancellable?
    
    private var character: Character?
    
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
        character = nil
        characterCell.prepareForReuse()
    }
    
    func setCharacter(_ character: Character) {
        characterCell.setCharacter(character)
        self.character = character
    }
    
    @objc func selectCharacter() {
        selectedCharacter = character
    }
}

private extension MainCharacterCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(characterCell)
        setupConstraints()
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self,
//                                                         action: #selector(selectCharacter)))
    }
    
    func setupConstraints() {
        characterCell.layout {
            $0 -|- contentView
            $0 |-| (contentView + 4.0)
            $0.height == characterCell.widthAnchor
        }
    }
}
