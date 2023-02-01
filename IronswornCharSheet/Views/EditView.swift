//
//  EditView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 15.03.2022.
//

import SwiftUI

struct EditView: View {
    let expSystemTypes = ["Vow System", "Legacy System"]
    @EnvironmentObject var hero: Hero
    @FocusState private var fieldIsFocused: Bool
    var body: some View {
        NavigationView {
            VStack {
                Text("CHARACTER NAME")
                    .frame(maxWidth: .infinity)
                    .padding(7)
                    .background(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.vertical, 20)
                TextField("Enter a new name", text: $hero.stats.name)
                    .textFieldStyle(.roundedBorder)
                    .focused($fieldIsFocused)
                Text("STATS")
                    .frame(maxWidth: .infinity)
                    .padding(7)
                    .background(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.vertical, 20)
                HStack {
                    VStack {
                        Text("Edge")
                        Text("\(hero.stats.edge)")
                            .font(.system(size: 40))
                            .padding(.top, -6)
                            .padding(.bottom, -2)
                        Stepper("Edge") {
                            hero.stats.edge += 1
                        } onDecrement: {
                            hero.stats.edge -= 1
                        } .labelsHidden()
                    }
                    Spacer()
                    VStack {
                        Text("Heart")
                        Text("\(hero.stats.heart)")
                            .font(.system(size: 40))
                            .padding(.top, -6)
                            .padding(.bottom, -2)
                        Stepper("Heart") {
                            hero.stats.heart += 1
                        } onDecrement: {
                            hero.stats.heart -= 1
                        } .labelsHidden()
                    }
                    Spacer()
                    VStack {
                        Text("Iron")
                        Text("\(hero.stats.iron)")
                            .font(.system(size: 40))
                            .padding(.top, -6)
                            .padding(.bottom, -2)
                        Stepper("Iron") {
                            hero.stats.iron += 1
                        } onDecrement: {
                            hero.stats.iron -= 1
                        } .labelsHidden()
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        Text("Shadow")
                        Text("\(hero.stats.shadow)")
                            .font(.system(size: 40))
                            .padding(.top, -6)
                            .padding(.bottom, -2)
                        Stepper("Shadow") {
                            hero.stats.shadow += 1
                        } onDecrement: {
                            hero.stats.shadow -= 1
                        } .labelsHidden()
                    }
                    Spacer()
                    VStack {
                        Text("Wits")
                        Text("\(hero.stats.wits)")
                            .font(.system(size: 40))
                            .padding(.top, -6)
                            .padding(.bottom, -2)
                        Stepper("Wits") {
                            hero.stats.wits += 1
                        } onDecrement: {
                            hero.stats.wits -= 1
                        } .labelsHidden()
                    }
                    Spacer()
                }
                .padding(.top, 20)
       
                Text("EXPERIENCE")
                    .frame(maxWidth: .infinity)
                    .padding(7)
                    .background(Color(hue: 0.56, saturation: 0.894, brightness: 0.564))
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.vertical, 20)
                Picker("Experience system", selection: $hero.stats.expSystem) {
                    ForEach(expSystemTypes, id: \.self) {
                        Text(NSLocalizedString($0, comment: ""))
                    }
                } .pickerStyle(.segmented)
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Hide") {
                        fieldIsFocused = false
                    }
                }
            }
            .padding(10)
            .navigationBarTitle("Edit character", displayMode: .inline)
            .onDisappear() {
                if hero.stats.name != "Name" {
                    hero.writeToFile()
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .environmentObject(Hero())
    }
}
