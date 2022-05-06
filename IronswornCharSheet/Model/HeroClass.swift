//
//  HeroClass.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 14.03.2022.
//

import Foundation

class Hero: ObservableObject {
    @Published var stats = CharacterStats()
    
    func getData(file: String) {
        stats = load(file)
        UserDefaults.standard.set(stats.name, forKey: "lastHero")
    }

    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileUrl = URL(fileURLWithPath: documentDirectoryPath)
        let file = fileUrl.absoluteURL.appendingPathComponent(filename)
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func writeToFile() {
        let documentDirectoryPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileUrl = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("\(String(describing: stats.name)).json")
            do{
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let JsonData = try encoder.encode(stats)
                try JsonData.write(to: fileUrl)
                print("записали файл \(stats.name).json")
            } catch {
                print("не получилось записать")
        }
    }
}
