//
//  LocationCollectionHeader.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import UIKit
import AutolayoutDSL

final class LocationCollectionHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.text = String(localized: "Locations")
        label.font = Fonts.markerFont(size: 32.0)
        label.textColor = Colors.rmBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        label.fill(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
