//
//  EpisodeCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import SwiftUI

struct EpisodeCell: View {
    var id: Int
    
    var body: some View {
        VStack {
            Image(systemName: "film")
                .resizable()
                .foregroundStyle(Color(uiColor: .systemGray6))
                .frame(width: 30.0, height: 30.0)
                .padding(.top, 8.0)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(uiColor: .systemGray6))
            Text("\(id)")
                .font(Font.custom("Marker felt", size: 22))
                .foregroundStyle(Color(uiColor: .systemGray6))
                .padding(.bottom, 4.0)
        }
        .background(Colors.rmBlue_SwiftUI)
        .clipShape(.rect(cornerRadius: 8.0))
        .frame(width: 70)
    }
}

#Preview {
    EpisodeCell(id: 1)
}
