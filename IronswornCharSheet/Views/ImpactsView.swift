//
//  ImpactsView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 31.03.2022.
//

import SwiftUI
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

struct ImpactsView: View {
    @FocusState private var fieldIsFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var hero: Hero
    @State var impact = Impact()
    @State private var vehicleList = ["None"]
    @State private var burdensList = ["Doomed", "Tormented", "Indebted"]
    @State private var misfortunesList = ["Wounded", "Shaken", "Unprepared"]
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Impact type")) {
                        Picker("Impact type", selection: $impact.type) {
                            ForEach(impact.typeList, id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            }
                        } .pickerStyle(.menu)
                    }
                    if impact.type == "Vehicle" {
                        Section(header: Text("Choose a vehicle")) {
                        Picker("Choose vehicle", selection: $impact.vehicle) {
                            ForEach(vehicleList, id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            } }
                        } .pickerStyle(.menu)
                    }
                    if impact.type == "Misfortunes" {
                        Section(header: Text("Choose a misfortune")) {
                        Picker("Choose an impact", selection: $impact.name) {
                            ForEach(misfortunesList, id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            } }
                        } .pickerStyle(.automatic)
                    }
                    if impact.type == "Burdens" {
                        Section(header: Text("Choose a burden")) {
                        Picker("Choose an impact", selection: $impact.name) {
                            ForEach(burdensList, id: \.self) {
                                Text(NSLocalizedString($0, comment: ""))
                            } }
                        } .pickerStyle(.automatic)
                    }
                    if impact.type != "Misfortunes" && impact.type != "Burdens" {
                        Section(header: Text("Impact name")) {
                            TextField("Enter impact name", text: $impact.name)
                            .focused($fieldIsFocused) }
                    }
                } .listStyle(.insetGrouped)
            }
            .navigationBarTitle("New impact", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
                ToolbarItem {
                    Button {
                        if impact.name == "" {
                            self.showAlert = true
                        } else {
                            hero.stats.impacts.append(impact)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Add")
                    } .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("You need to enter an impact name."))
                    }
                }
            }
        }
        .onAppear {
            vehicleList = ["None"]
            for asset in hero.stats.assets {
                if asset.type == "Vehicle" || asset.type == "Support vehicle" {
                    vehicleList.append(asset.name)
                }
            }
            misfortunesList = []
            var tempMisList: [String] = []
            let etalonMis = ["Wounded", "Shaken", "Unprepared"]
            for impact in hero.stats.impacts {
                if impact.name == "Wounded" || impact.name == "Shaken" || impact.name == "Unprepared" {
                    tempMisList.append(impact.name)
                }
            }
            misfortunesList = etalonMis.difference(from: tempMisList)
            burdensList = []
            var tempBurdensList: [String] = []
            let etalonBurdens = ["Doomed", "Tormented", "Indebted"]
            for impact in hero.stats.impacts {
                if impact.name == "Doomed" || impact.name == "Tormented" || impact.name == "Indebted" {
                    tempBurdensList.append(impact.name)
                }
            }
            burdensList = etalonBurdens.difference(from: tempBurdensList)
        }
    }
}

struct ImpactsView_Previews: PreviewProvider {
    static var previews: some View {
        ImpactsView()
            .environmentObject(Hero())
    }
}
