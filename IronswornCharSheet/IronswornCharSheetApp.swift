//
//  IronswornCharSheetApp.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 14.03.2022.
//

import SwiftUI

@main
struct IronswornCharSheetApp: App {
    @StateObject private var hero = Hero()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(hero)
        }
    }
}
