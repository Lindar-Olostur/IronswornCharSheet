//
//  NewAssetView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 22.03.2022.
//

import SwiftUI

struct NewAssetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var hero: Hero
    @State var asset = Asset()
    @FocusState private var fieldIsFocused: Bool

    let rank = [1, 2, 3]
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Asset name")) {
                        TextField("Enter asset name", text: $asset.name)
                            .font(.system(.headline))
                            .focused($fieldIsFocused)
                        TextField("Other", text: $asset.status)
                            .focused($fieldIsFocused)
                    }
                    Section(header: Text("Asset type")) {
                        Picker("Asset type", selection: $asset.type) {
                            ForEach(asset.typeList.sorted(), id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    
                    Section(header: Text("Asset stat")) {
                        Toggle(isOn: $asset.statIsEnabled) {
                            Text("Stat is enabled")
                        }
                        if asset.statIsEnabled {
                            TextField("Stat name", text: $asset.statName)
                                .focused($fieldIsFocused)
                            Stepper("Max stat value: \(asset.statMax)", value: $asset.statMax)
                        }
                    }
                    Section(header: Text("Rank & Description")) {
                        Picker(selection: $asset.rank, label: Text("rank")) {
                            ForEach(rank, id: \.self) {
                                Text("\($0)")
                            }
                        } .pickerStyle(.segmented)
                            .padding(.vertical)

                        TextEditor(text: $asset.firstRankText)
                            .frame(minHeight: 150)
                            .focused($fieldIsFocused)
                        if asset.rank > 1 {
                            TextEditor(text: $asset.secondRankText)
                            .frame(minHeight: 150)
                            .transition(.slide)
                            .focused($fieldIsFocused)
                        }
                        if asset.rank > 2 {
                            TextEditor(text: $asset.thirdRankText)
                            .frame(minHeight: 150)
                            .focused($fieldIsFocused) }
                    }
                }
                .listStyle(.insetGrouped)
                    
            }
            .navigationBarTitle("New asset", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
                ToolbarItem {
                    Button {
                        addNewAsset()
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
    func addNewAsset() {
        hero.stats.assets.append(asset)
        hero.writeToFile()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct NewAssetView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssetView()
            .environmentObject(Hero())
    }
}
