//
//  Constants.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 19/10/24.
//

import Foundation
import UIKit
import SwiftUI

struct Colors {
    static let rmBlue = UIColor(named: "RMBlue")
    static let rmPurple = UIColor(named: "RMPurple")
    static let rmGreen = UIColor(named: "RMGreen")
    
    static let rmGreen_SwiftUI = Color(uiColor: rmGreen ?? .clear)
    static let rmPurple_SwiftUI = Color(uiColor: rmPurple ?? .clear)
    static let rmBlue_SwiftUI = Color(uiColor: rmBlue ?? .clear)
}

struct Fonts {
    static func markerFont(size: CGFloat) -> UIFont? {
        UIFont(name: "Marker felt", size: size)
    }
}
