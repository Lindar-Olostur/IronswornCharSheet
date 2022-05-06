//
//  CharacterModel.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 14.03.2022.
//

import Foundation

struct CharacterStats: Codable {
    var name: String = "Name" {
        willSet {UserDefaults.standard.set(newValue, forKey: "lastHero")}
    }
    var health: Int = 5 {
        didSet {
            if health < 0 {health = 0}
            if health > 5 {health = 5}
            for impact in impacts {
                if impact.name == "Wounded" {
                    if oldValue < health {
                        health = oldValue
                    }
                }
            }
        }
    }
    var spirit: Int = 5 {
        didSet {
            if spirit < 0 {spirit = 0}
            if spirit > 5 {spirit = 5}
            for impact in impacts {
                if impact.name == "Shaken" {
                    if oldValue < spirit {
                        spirit = oldValue
                    }
                }
            }
        }
    }
    var supply: Int = 5 {
        didSet {
            if supply < 0 {supply = 0}
            if supply > 5 {supply = 5}
            for impact in impacts {
                if impact.name == "Unprepared" {
                    if oldValue < supply {
                        supply = oldValue
                    }
                }
            }
        }
    }

    var edge: Int = 0 {
        didSet {
            if edge < 0 {edge = 0}
            if edge > 5 {edge = 5}
        }
    }
    var heart: Int = 0 {
        didSet {
            if heart < 0 {heart = 0}
            if heart > 5 {heart = 5}
        }
    }
    var iron: Int = 0 {
        didSet {
            if iron < 0 {iron = 0}
            if iron > 5 {iron = 5}
        }
    }
    var shadow: Int = 0 {
        didSet {
            if shadow < 0 {shadow = 0}
            if shadow > 5 {shadow = 5}
        }
    }
    var wits: Int = 0 {
        didSet {
            if wits < 0 {wits = 0}
            if wits > 5 {wits = 5}
        }
    }
    
    var momentum: Int = 2
    var resetMomentum: Int = 2
    var maxMomentum: Int = 10
    var tracks: [Track] = [Track(id: UUID(), name: "Quests", description: "", rank: 4, currentProgress: 0.0, type: "Legacy", fullfilled: false, forsaken: false, role: ""), Track(id: UUID(), name: "Bonds", description: "", rank: 4, currentProgress: 0.0, type: "Legacy", fullfilled: false, forsaken: false, role: ""), Track(id: UUID(), name: "Discoveries", description: "", rank: 4, currentProgress: 0.0, type: "Legacy", fullfilled: false, forsaken: false, role: "")]//[Track(name: "Popa", rank: 0, currentProgress: 4), Track(name: "Pipa", rank: 3, currentProgress: 2.75)]
    var assets: [Asset] = []//[Asset(name: "Космический корабль", rank: 3, firstRankText: "Твой вооруженный многоцелевой космолет подходит как для межзвездных так и внутри атмосферных перелетов. Он может с комфортом перевозить несколько человек, имеет место для груза, а также может нести и запускать вспомогательный странспорт. Когда ты Развиваешься, ты можешь потратить опыт на оснащение этого корабля дополнительными модулями.", secondRankText: "Когда ты Завершаешь экспедицию (опасную или выше) и добиваешься супеха, это путешествие усиливает твою связь со своим кораблем и союзниками на ботру. Ты и твои союзники могут отметить 1 тик на своей шкале связей.", thirdRankText: "Когда ты Выдерживаешь повреждения, ты можешь бросить +нрав. Делая так, Получи стресс(-1) в случае частичного успеха или провала.", status: "Состояние: исправен", statIsEnabled: true, statName: "Прочность", statMax: 5, statCurrent: 5), Asset(name: "Глайдер", rank: 1, firstRankText: "Твой вооруженный многоцелевой космолет подходит как для межзвездных так и внутри атмосферных перелетов. Он может с комфортом перевозить несколько человек, имеет место для груза, а также может нести и запускать вспомогательный странспорт. Когда ты Развиваешься, ты можешь потратить опыт на оснащение этого корабля дополнительными модулями.", secondRankText: "", thirdRankText: "", status: "Состояние: исправен", statIsEnabled: false, statName: "Прочность", statMax: 5, statCurrent: 5)]
    var currentVehicle = "None"
    var impacts: [Impact] = [] {
        didSet { changeResetMomentum() }
    }
    var expVow = 0 {
        didSet {
            if expVow < 0 {expVow = 0}
        }
    }
    var expSystem = "Vow System"
    
    mutating func changeResetMomentum() {
        maxMomentum = 10 - impacts.count
        var trueImpacts = 0
        for impact in impacts {
            if impact.type != "Vehicle" { trueImpacts += 1 }
        }
        
        if currentVehicle != "None" {
            for impact in impacts {
                if impact.vehicle == currentVehicle { trueImpacts += 1 }
            }
        }
        
        if trueImpacts == 0 {resetMomentum = 2}
        if trueImpacts == 1 {resetMomentum = 1}
        if trueImpacts > 1 {resetMomentum = 0}
    }
}

struct Asset: Codable, Hashable, Identifiable {
    var id = UUID()
    var typeList = ["Vehicle", "Support vehicle", "Vehicle module", "Path", "Companion", "Deed", "Combat talent", "Ritual", "Other"]
    var type = "Other"
    var name = ""
    var rank = 1
    var firstRankText = ""
    var secondRankText = ""
    var thirdRankText = ""
    var status = ""
    var statIsEnabled = false
    var statName = ""
    var statMax = 5
    var statCurrent = 5
}

struct Impact: Codable, Hashable, Identifiable {
    var id = UUID()
    var name = ""
    var typeList = ["Other", "Misfortunes", "Lasting effects", "Burdens", "Vehicle"]
    var type = "Other"
    var vehicle = ""  
}

struct Track: Codable, Hashable, Identifiable {
    var id = UUID()
    var name = ""
    var description = ""
    var rankList = ["Troublesome", "Dangerous", "Formidable", "Extreme", "Epic"]
    var stepList = [3.0, 2.0, 1.0, 0.5, 0.25]
    var rank = 2
    var currentLegacyProgress = 0.0 {
        didSet {
            if currentLegacyProgress < 0.0 {currentLegacyProgress = 0.0}
            if currentLegacyProgress >= 10.0 {currentLegacyProgress = 10.0}
            if type == "Legacy" && currentLegacyProgress == 0.0 {legacy10Up = false}
        }
    }
    var currentProgress = 0.0 {
        didSet {
            if currentProgress < 0.0 {currentProgress = 0.0}
            if currentProgress >= 10.0 {currentProgress = 10.0}
            if type == "Legacy" && currentProgress >= 10.0 {legacy10Up = true}
        }
    }
    var typeList = ["Vow", "Connection", "Expedition", "Fray"]
    var type = "Vow"
    var fullfilled = false
    var forsaken = false
    var role = ""
    var legacyExp: Int {
        get {
            if !legacy10Up {
                return Int(floor(currentProgress)*2)
            } else {
                return Int(floor(currentLegacyProgress) + floor(currentProgress)*2)
            }
        }
    }
    var legXpForSpend = 0
    var legacy10Up = false
}
