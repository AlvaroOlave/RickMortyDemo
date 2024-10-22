//
//  CharacterDetailView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 22/10/24.
//

import SwiftUI

struct CharacterDetailView: View {
    
    var character: Character
    
    let selectedLocation: (String) -> Void
    let selectedEpisode: (Int?) -> Void
    
    @State private var selectedEpisodeId: Int?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12.0) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .clipShape(.rect(cornerRadius: 8.0))
                } placeholder: {
                    Image("rmPlaceholder")
                        .resizable()
                        .clipShape(.rect(cornerRadius: 8.0))
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
             
                Text("Species: \(character.species), \(character.gender.rawValue)")
                    .rmLabelStyle()
                
                Text("Status: \(character.status.rawValue)")
                    .rmLabelStyle()
                
                locationView("Origin: \(character.origin.name)")
                    .onTapGesture {
                        selectedLocation(character.origin.url)
                    }
                locationView("Current location: \(character.location.name)")
                    .onTapGesture {
                        selectedLocation(character.location.url)
                    }
                let episodeIds = character.episode.map({ idFromURL($0)}).compactMap({ $0 })
                EpisodesList(ids: episodeIds, selectedEpisode: $selectedEpisodeId)
            }
        }
        .background(Colors.rmGreen_SwiftUI)
        .onChange(of: selectedEpisodeId) {
            selectedEpisode(selectedEpisodeId)
        }
    }
    
    @ViewBuilder func locationView(_ name: String) -> some View {
        HStack {
            Text(name)
                .rmLabelStyle()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 15, height: 20)
                .bold()
                .padding(.trailing)
                .foregroundColor(Colors.rmBlue_SwiftUI)
        }
    }
    
    func idFromURL(_ url: String) -> Int? {
        guard let id = url
            .components(separatedBy: "/")
            .last
        else { return nil }
        return Int(id)
    }
}

extension Text {
    func rmLabelStyle() -> some View {
        self.font(Font.custom("Marker felt", size: 24))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Colors.rmBlue_SwiftUI)
            .padding(.leading, 24)
            .padding(.top, 12)
            .lineLimit(3)
    }
}

#Preview {
    CharacterDetailView(character: Character(with: CharacterDTO(id: 0,
                                                                name: "",
                                                                status: "",
                                                                species: "Human",
                                                                type: "",
                                                                gender: "",
                                                                origin: CharacterOrigin(name: "CharacterOrigin",
                                                                                        url: ""),
                                                                location: CharacterLocation(name: "CharacterLocation",
                                                                                            url: ""),
                                                                image: "",
                                                                episode: [],
                                                                url: "",
                                                                created: "")),
                        selectedLocation: {_ in }, selectedEpisode: {_ in })
}
