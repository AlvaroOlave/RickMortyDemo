//
//  EpisodesList.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import SwiftUI

struct EpisodesList: View {
    
    var ids: [Int]
    
    @Binding var selectedEpisode: Int?
    
    var body: some View {
        VStack {
            Text("Episodes")
                .rmLabelStyle()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(ids, id: \.self) { id in
                        EpisodeCell(id: id)
                            .onTapGesture {
                                selectedEpisode = id
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    EpisodesList(ids: [1, 2, 3, 4, 5], 
                 selectedEpisode: .constant(1))
}
