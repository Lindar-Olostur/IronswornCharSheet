//
//  ContentView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 14.03.2022.
//

import SwiftUI

struct HSSButtons: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
            .cornerRadius(15)
            .padding(.horizontal, 7)
            .animation(.easeIn, value: 5)
            .opacity(configuration.isPressed ? 0.5 : 1)
        }
}



struct StatsView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var hero: Hero
    @State private var openedEditView = false
    @State private var openedLoadView = false
    @State private var openedRollView = false
    @State private var openedNewImpactView = false
    @State private var vehicleList = ["None"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Vehicles
                if vehicleList != ["None"] {
                    Divider()
                    HStack(alignment: .firstTextBaseline) {
                        Text("Current vehicle:")
                            .font(.system(size: 15))
                            .padding(.leading)
                        Picker("Current vehicle", selection: $hero.stats.currentVehicle) {
                            ForEach(vehicleList, id: \.self) {
                                Text($0)
                            }
                        } 
                        Spacer()
                    }
                }
                // Stats
                HStack(spacing: -5) {
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Edge", statValue: hero.stats.edge)) {
                                Text("\(hero.stats.edge)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 40))
                            .accessibilityIdentifier("Edge")
                        Text("Edge")
                    }
                    
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Heart", statValue: hero.stats.heart)) {
                                Text("\(hero.stats.heart)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 40))
                        Text("Heart")
                    }
                    
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Iron", statValue: hero.stats.iron)) {
                                Text("\(hero.stats.iron)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 40))
                        Text("Iron")
                    }
                    
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Shadow", statValue: hero.stats.shadow)) {
                                Text("\(hero.stats.shadow)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 40))
                        Text("Shadow")
                    }
                    
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Wits", statValue: hero.stats.wits)) {
                                Text("\(hero.stats.wits)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 40))
                        Text("Wits")
                    }
                }
                //.padding(.top, 40)
                .padding(.bottom, 20)
                // Param
                HStack(spacing: -5) {
                    VStack {
                        Button {
                            //UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        } label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Health", statValue: hero.stats.health)) {
                                Text("\(hero.stats.health)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 60))
                        
                        Stepper("health", onIncrement: { hero.stats.health += 1}, onDecrement:{ hero.stats.health -= 1})
                            .labelsHidden()
                        Text("Health")
                    }
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Spirit", statValue: hero.stats.spirit)) {
                                Text("\(hero.stats.spirit)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 60))
                        
                        Stepper("spirit") {
                            hero.stats.spirit += 1
                        } onDecrement: {
                            hero.stats.spirit -= 1
                        }
                        .labelsHidden()
                        Text("Spirit")
                    }
                    VStack {
                        Button {} label: {
                            NavigationLink(destination: RollView(hero: self.hero, isProgressRoll: false, statName: "Supply", statValue: hero.stats.supply)) {
                                Text("\(hero.stats.supply)")}
                        } .buttonStyle(HSSButtons())
                            .font(.system(size: 60))
                        
                        Stepper("supply") {
                            hero.stats.supply += 1
                        } onDecrement: {
                            hero.stats.supply -= 1
                        }
                        .labelsHidden()
                        Text("Supply")
                    }
                }
                // Momentum
                HStack(spacing: -5) {
                    VStack {
                        Button {
                            hero.stats.momentum -= 1
                            if hero.stats.momentum < -6 {
                                hero.stats.momentum = -6 }
                            } label: {
                            Text("<")
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                        .background(Color(hue: 0.56, saturation: 0.011, brightness: 0.918))
                        .cornerRadius(15)
                        .padding(.horizontal, 7)
                        .font(.system(size: 80))
                        
                        Text("Reset: +\(hero.stats.resetMomentum)")

                    }
                    VStack {
                        Button {
                            //
                        } label: {
                            Text(hero.stats.momentum >= 0 ? "+\(hero.stats.momentum)" : "\(hero.stats.momentum)")
                        }
                        .disabled(true)
                        .padding(.vertical)
                        .frame(width: 170)
                        .foregroundColor(.white)
                        .background(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                        .cornerRadius(15)
                        .padding(.horizontal, 7)
                        .font(.system(size: 80))
                        
                        Text("Momentum")

                    }
                    VStack {
                        Button {
                            hero.stats.momentum += 1
                            if hero.stats.momentum > hero.stats.maxMomentum {
                                hero.stats.momentum = hero.stats.maxMomentum
                            }

                        } label: {
                            Text(">")
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                        .background(Color(hue: 0.56, saturation: 0.011, brightness: 0.918))
                        .cornerRadius(15)
                        .padding(.horizontal, 7)
                        .font(.system(size: 80))
                        
                        Text("Max: +\(hero.stats.maxMomentum)")
                    }
                }
                
                // Impacts
                List {
                    Section(header:
                                HStack {
                                Text("Impacts").font(.title)
                        Spacer()
                        Button {
                            self.openedNewImpactView.toggle()
                        }
                    label: {
                            Image(systemName: "plus")
                        } .sheet(isPresented: $openedNewImpactView) {
                            ImpactsView()
                        }
                    }
                    ) {
                        ForEach(hero.stats.impacts, id: \.self) {impact in
                            Text(NSLocalizedString(impact.name, comment: ""))
                        }
                        .onDelete(perform: deleteImpact)
                        
                    }
                } .listStyle(.inset)
                Divider()
                if hero.stats.expSystem == "Vow System" {
                    HStack {
                        Stepper {
                            Text("Experience: \(hero.stats.expVow)").font(.system(size: 19))
                        } onIncrement: {
                            hero.stats.expVow += 1
                        } onDecrement: {
                            hero.stats.expVow -= 1
                        }
                        
                    } .padding()
                }
            }
            .navigationBarTitle("\(hero.stats.name)", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        self.openedLoadView.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    } .sheet(isPresented: $openedLoadView) {
                        LoadView(hero: self.hero)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        self.openedEditView.toggle()
                    } label: {
                        Text("Edit")
                    } .sheet(isPresented: $openedEditView) {
                        EditView()//hero: self.hero)
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if let last = UserDefaults.standard.string(forKey: "lastHero") {
                        hero.getData(file: "\(last).json")}
                }
                else if newPhase == .inactive {
                    hero.writeToFile()
                }
                else if newPhase == .background {
                    hero.writeToFile()
                }
            }
        } .onAppear {
            vehicleList = ["None"]
            for asset in hero.stats.assets {
                if asset.type == "Vehicle" || asset.type == "Support vehicle" {
                    vehicleList.append(asset.name)
                }
            }
        }
    }
    func deleteImpact(at offsets: IndexSet) {
        // let assetsToDelete = offsets.map { hero.stats.assets[$0] } //поиск ассета
        hero.stats.impacts.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(Hero())
            //.environment(\.locale, .init(identifier: "ru"))
    }
}
