//
//  MainTabView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 23.03.2022.
//

import SwiftUI

struct MainTabView: View {
    
    @State var screen = 0
    
    
    var body: some View {
        TabView(selection: $screen) {
            StatsView()
                .tabItem() {
                    Image(systemName: "person")
                    Text("Stats")
                }.tag(0)
            AssetsListView()
                .tabItem {
                    Image(systemName: "list.star")
                    Text("Assets")
                }.tag(1)
            TrackListView()
                .tabItem {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    Text("Tracks")
                }.tag(2)
            NotesView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Notes")
                }.tag(3)
        } 
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(Hero())
    }
}
