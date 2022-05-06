//
//  EditAssetView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 25.03.2022.
//

import SwiftUI

struct EditAssetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var hero: Hero
    @State var asset: Asset
    var assetIndex: Int {
        hero.stats.assets.firstIndex(where: { $0.id == $asset.id})!
    }
    let rank = [1, 2, 3]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Asset name")) {
                        TextField("Enter asset name", text: $hero.stats.assets[assetIndex].name)
                            .font(.system(.headline))
                        TextField("Other", text: $hero.stats.assets[assetIndex].status)
                    }
                    Section(header: Text("Asset type")) {
                        Picker("Asset type", selection: $hero.stats.assets[assetIndex].type) {
                            ForEach(hero.stats.assets[assetIndex].typeList.sorted(), id: \.self) {
                                Text($0)
                            }
                        } .pickerStyle(.menu)
                    }
                    Section(header: Text("Asset stat")) {
                        Toggle(isOn: $hero.stats.assets[assetIndex].statIsEnabled) {
                            Text("Stat is enabled")
                        }
                        if asset.statIsEnabled {
                            TextField("Stat name", text: $hero.stats.assets[assetIndex].statName)
                            Stepper("Max stat value: \(hero.stats.assets[assetIndex].statMax)", value: $hero.stats.assets[assetIndex].statMax)
                        }
                    }
                    Section(header: Text("Rank & Description")) {
                        Picker(selection: $hero.stats.assets[assetIndex].rank, label: Text("rank")) {
                            ForEach(rank, id: \.self) {
                                Text("\($0)")
                            }
                        } .pickerStyle(.segmented)
                            .padding(.vertical)

                        TextEditor(text: $hero.stats.assets[assetIndex].firstRankText)
                            .frame(minHeight: 150)
                        if asset.rank > 1 {
                            TextEditor(text: $hero.stats.assets[assetIndex].secondRankText)
                            .frame(minHeight: 150)
                            .transition(.slide)
                        }
                        if asset.rank > 2 {
                            TextEditor(text: $hero.stats.assets[assetIndex].thirdRankText)
                            .frame(minHeight: 150) }
                    }
                }
                .listStyle(.insetGrouped)
                    
            }
            .navigationBarTitle("New asset", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        saveAsset()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    func saveAsset() {
        hero.writeToFile()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditAssetView_Previews: PreviewProvider {
    static var previews: some View {
        EditAssetView(asset: Asset())
            .environmentObject(Hero())
    }
}
