//
//  EditTrackView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 06.04.2022.
//

import SwiftUI

struct EditTrackView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var hero: Hero
    @FocusState private var fieldIsFocused: Bool
    @State var track: Track
    var trackIndex: Int {
        hero.stats.tracks.firstIndex(where: { $0.id == $track.id}) ?? 0//!
    }
    let rank = [0, 1, 2, 3, 4]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Progress track type")) {
                        Picker("", selection: $hero.stats.tracks[trackIndex].type) {
                            ForEach(hero.stats.tracks[trackIndex].typeList.sorted(), id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    Section(header: Text("Track name")) {
                        TextField("Enter a track name", text: $hero.stats.tracks[trackIndex].name)
                            .font(.system(.headline))
                            .focused($fieldIsFocused)
                    }
                    Section(header: Text("Choose track rank")) {
                        Picker("track rank", selection: $hero.stats.tracks[trackIndex].rank) {
                            ForEach(rank, id: \.self) {
                                Text(NSLocalizedString(hero.stats.tracks[trackIndex].rankList[$0], comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    if hero.stats.tracks[trackIndex].type == "Connection" {
                        Section(header: Text("Connection role")) {
                            TextEditor(text: $hero.stats.tracks[trackIndex].role)
                                .focused($fieldIsFocused)
                        }
                    }
                    Section(header: Text("Track description")) {
                        TextEditor(text: $hero.stats.tracks[trackIndex].description)
                            .frame(maxHeight: .infinity)
                            .focused($fieldIsFocused)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationBarTitle("Edit progress track", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
                ToolbarItem {
                    Button {
                        saveTrack()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    func saveTrack() {
        hero.writeToFile()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditTrackView_Previews: PreviewProvider {
    static var previews: some View {
        EditTrackView(track: Track())
            .environmentObject(Hero())
    }
}
