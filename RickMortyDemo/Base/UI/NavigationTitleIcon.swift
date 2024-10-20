//
//  NavigationTitleIcon.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation
import UIKit

final class NavigationTitleIcon: UIImageView {
    
    init() {
        super.init(image: UIImage(named: "Rick_and_Morty_Logo"))
        self.contentMode = .scaleAspectFit
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
