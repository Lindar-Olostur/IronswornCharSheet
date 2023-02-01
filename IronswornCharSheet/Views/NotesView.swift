//
//  NotesView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 02.09.2022.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var hero: Hero
    @FocusState private var fieldIsFocused: Bool
    var body: some View {
        NavigationView {
            TextEditor(text: $hero.stats.notes)
            .focused($fieldIsFocused)
            .navigationBarTitle("Notes", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView().environmentObject(Hero())
    }
}
