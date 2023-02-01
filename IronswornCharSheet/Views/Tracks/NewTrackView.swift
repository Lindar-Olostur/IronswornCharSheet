//
//  NewVowView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 05.04.2022.
//

import SwiftUI

struct NewTrackView: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var fieldIsFocused: Bool
    @EnvironmentObject var hero: Hero
    @State var track = Track()
    
    let rank = [0, 1, 2, 3, 4]
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Progress track type")) {
                        Picker("Prog type", selection: $track.type) {
                            ForEach(track.typeList.sorted(), id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    Section(header: Text("Track name")) {
                        TextField("Enter a track name", text: $track.name)
                            .font(.system(.headline))
                            .focused($fieldIsFocused)
                    }
                    Section(header: Text("Choose track rank")) {
                        Picker("track rank", selection: $track.rank) {
                            ForEach(rank, id: \.self) {
                                Text(NSLocalizedString(track.rankList[$0], comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    if track.type == "Connection" {
                        Section(header: Text("Connection role")) {
                            TextEditor(text: $track.role)
                                .focused($fieldIsFocused)
                        }
                    }
                    Section(header: Text("Track description")) {
                        TextEditor(text: $track.description)
                            .frame(maxHeight: .infinity)
                            .focused($fieldIsFocused)
                    }
                }
                .listStyle(.insetGrouped)
                
            }
            .navigationBarTitle("New progress track", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
                ToolbarItem {
                    Button {
                        addNewTrack()
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
    func addNewTrack() {
        hero.stats.tracks.append(track)//insert(track, at: 0)
        hero.writeToFile()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct NewVowView_Previews: PreviewProvider {
    static var previews: some View {
        NewTrackView()
            .environmentObject(Hero())
    }
}
