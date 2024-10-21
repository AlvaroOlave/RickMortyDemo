//
//  
//  MainCharacterCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//
//
import UIKit
import AutolayoutDSL

final class MainCharacterCell: CharacterCell { 
    
    @Published var selectedCharacter: Character?
    
    private let character: Character
    
    override init(character: Character) {
        self.character = character
        super.init(character: character)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectCharacter)))
    }
    
    @objc func selectCharacter() {
        selectedCharacter = character
    }
}
