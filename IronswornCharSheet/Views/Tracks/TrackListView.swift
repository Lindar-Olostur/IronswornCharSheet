//
//  VowListView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 04.04.2022.
//

import SwiftUI

struct TrackListView: View {
    @EnvironmentObject var hero: Hero
    @State var editMode: EditMode = .inactive
    @State private var openedEditTrack = false
    @State private var openedNewTrack = false
    @State var openedRollView = false
    @State var valueNameForRoll = "Track Name"
    @State var valueForRoll = 0
    @State var tappedTrack: Track?
    
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $tappedTrack) {
                    if check(type: "Vow") {
                        Section(header: Text("Vows")) {
                            ForEach(hero.stats.tracks, id: \.self) {track in
                                if track.type == "Vow" {
                                    TrackRowView(track: track, valueForRoll: $valueForRoll, valueNameForRoll: $valueNameForRoll, openedRollView: $openedRollView) }
                            }
                            .onDelete(perform: deleteTrack)
                            .onMove(perform: onMove)
                        }
                    }
                    if check(type: "Connection") {
                        Section(header: Text("Connections")) {
                            ForEach(hero.stats.tracks, id: \.self) {track in
                                if track.type == "Connection" {
                                    TrackRowView(track: track, valueForRoll: $valueForRoll, valueNameForRoll: $valueNameForRoll, openedRollView: $openedRollView) }
                            }
                            .onDelete(perform: deleteTrack)
                            .onMove(perform: onMove)
                        }
                    }
                    if check(type: "Expedition") {
                        Section(header: Text("Expeditions")) {
                            ForEach(hero.stats.tracks, id: \.self) {track in
                                if track.type == "Expedition" {
                                    TrackRowView(track: track, valueForRoll: $valueForRoll, valueNameForRoll: $valueNameForRoll, openedRollView: $openedRollView) }
                            }
                            .onDelete(perform: deleteTrack)
                            .onMove(perform: onMove)
                        }
                    }
                    if check(type: "Fray") {
                        Section(header: Text("Frays")) {
                            ForEach(hero.stats.tracks, id: \.self) {track in
                                if track.type == "Fray" {
                                    TrackRowView(track: track, valueForRoll: $valueForRoll, valueNameForRoll: $valueNameForRoll, openedRollView: $openedRollView) }
                            }
                            .onDelete(perform: deleteTrack)
                            .onMove(perform: onMove)
                        }
                    }
                    if hero.stats.expSystem == "Legacy System" {
                        Section(header: Text("Legacy")) {
                            ForEach(hero.stats.tracks, id: \.self) {track in
                                if track.type == "Legacy" {
                                    TrackRowView(track: track, valueForRoll: $valueForRoll, valueNameForRoll: $valueNameForRoll, openedRollView: $openedRollView) }
                            }
                            //.onDelete(perform: deleteTrack)
                            .onMove(perform: onMove)
                        }
                    }
                }
                .listStyle(.sidebar)
                .navigationBarTitle("Tracks", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.openedNewTrack.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $openedNewTrack) {
                            NewTrackView()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if hero.stats.tracks.count > 3 || hero.stats.expSystem == "Legacy System" {
                            EditButton()
                                .sheet(isPresented: $openedEditTrack) {
                                    EditTrackView(track: tappedTrack!)
                                }
                                .onChange(of: $editMode.wrappedValue, perform: { value in
                                    if value.isEditing {
                                        tappedTrack = nil
                                    }
                                    else {
                                        if tappedTrack != nil {
                                            openedEditTrack.toggle() }
                                    }
                                }
                            )
                        }
                    }
                }
                NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: true, statName: valueNameForRoll, statValue: valueForRoll), isActive: $openedRollView) {
                    EmptyView()
                }
            }
            .onAppear() {
                if hero.stats.name != "Name" {
                    hero.writeToFile()
                }
            }
            .environment(\.editMode, self.$editMode)
        }
    }
    private func deleteTrack(at offsets: IndexSet) {
        hero.stats.tracks.remove(atOffsets: offsets)
    }
    private func onMove(source: IndexSet, destination: Int) {
        hero.stats.tracks.move(fromOffsets: source, toOffset: destination)
        }
    func check(type: String) -> Bool {
        for track in hero.stats.tracks {
            if track.type == type {
                return true
            }
        }
        return false
    }
}

struct VowListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
            .environmentObject(Hero())
    }
}
