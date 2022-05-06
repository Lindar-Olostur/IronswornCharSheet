//
//  AssetsListView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 23.03.2022.
//

import SwiftUI


struct AssetsListView: View {
    @EnvironmentObject var hero: Hero
    @State var editMode: EditMode = .inactive
    @State private var openedEditAsset = false
    @State private var openedNewAsset = false
    @State var tappedItem: Asset?
    
    var body: some View {
        NavigationView {
            List(selection: $tappedItem) {
                ForEach(hero.stats.assets, id: \.self) {asset in
                    AssetRowView(asset: asset)
                }
                .onDelete(perform: deleteAsset)
            }
            .listStyle(.inset)
            .navigationBarTitle("Assets", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        self.openedNewAsset.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $openedNewAsset) {
                        NewAssetView()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if hero.stats.assets != [] {
                        EditButton()
                            .sheet(isPresented: $openedEditAsset) {
                                EditAssetView(asset: tappedItem!)
                            }
                            .onChange(of: $editMode.wrappedValue, perform: { value in
                                if value.isEditing {
                                    tappedItem = nil
                                }
                                else {
                                    if tappedItem != nil {
                                        openedEditAsset.toggle() }
                                }
                            })
                    }
                }
            }
            .environment(\.editMode, self.$editMode)
            .onAppear() {
                if hero.stats.name != "Name" {
                    hero.writeToFile()
                }
            }
        }
    }
    func deleteAsset(at offsets: IndexSet) {
        // let assetsToDelete = offsets.map { hero.stats.assets[$0] } //поиск ассета
        hero.stats.assets.remove(atOffsets: offsets)
    }
}

struct AssetsListView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsListView()
            .environmentObject(Hero())
    }
}
