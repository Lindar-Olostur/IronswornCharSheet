//
//  LoadView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 15.03.2022.
//

import SwiftUI

struct LoadView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var hero: Hero
    @State private var files: [String] = []
    
    func directoryContents() -> [String] {
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: documentDirectoryPath)
        var list: [String] = []
        while let file = files?.nextObject() {
            list.append(file as! String)
        }
        return list
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(files, id: \.self) { file in
                        Text("\((file as NSString).deletingPathExtension)")
                            .onTapGesture { loadFile(id: file)
                            }
                    }
                    .onDelete(perform: deleteFile)
                    
                }
                Spacer()
                Button("Create new character") {
                    newCharacter()
                }
            }
            .onAppear {files = directoryContents()}
            .navigationBarTitle("List of characters", displayMode: .inline)
        }
    }
    
    func deleteFile(at offsets: IndexSet) {
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileUrl = URL(fileURLWithPath: documentDirectoryPath)
        guard let index = Array(offsets).first else { return }
        do {
            try FileManager.default.removeItem(at: fileUrl.appendingPathComponent("\(files[index])"))
        } catch {
          //error
        }
        files.remove(atOffsets: offsets)
    }
    
    func loadFile(id: String) {
        hero.writeToFile()
        hero.getData(file: id)
        self.presentationMode.wrappedValue.dismiss()
    }
    func newCharacter() {
        hero.writeToFile()
        hero.stats = CharacterStats()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView(hero: Hero())
    }
}
