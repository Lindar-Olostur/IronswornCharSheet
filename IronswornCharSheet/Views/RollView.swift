//
//  RollView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 16.03.2022.
//
//

import SwiftUI
import AVFoundation
var audioPlayer: AVAudioPlayer?

struct RollView: View {
    @Environment(\.presentationMode) var presentationMode
        
    @ObservedObject var hero: Hero
    
    @State private var actionDie = 0
    @State private var actionRoll = 90
    @State private var challengeDie1 = -1
    @State private var challengeDie2 = -1
    @State private var modifier = 0
    @State private var match = false
    
    let RollType1 = ["Action Roll", "Oracle Roll"]
    let RollType2 = ["Progress Roll", "Oracle Roll"]
    var isProgressRoll: Bool
    
    @State private var selectedRollType: Int = 0//"Action Roll"
    
    var firstDieIsBitten = false
    var secondDieIsBitten = false
    
    @State var burneDice1 = false
    @State  var burneDice2 = false
    @State var burneTo: String? = nil
    
    enum results: String {
        case miss = "Miss"
        case hit = "Hit"
        case strongHit = "Strong Hit"
    }
    
    @State var textOnRollButton = "ROLL"
    
    @State private var isAnimated = false
    @State private var spinning = 0.0
    let animationTime = 0.5
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State var isTimerRunning = false
    
    enum howManyDiceToRoll: String {
        case action = "action"
        case challenge1 = "challenge1"
        case challenge2 = "challenge2"
        case all = "all"
    }
    
    @State var whatIsRoll = "all"
    
    var statName: String
    var statValue: Int
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedRollType == 0 && !isProgressRoll {
                    VStack(spacing: -5) {
                        HStack {
                            VStack {
                                Text("Action Dice")
                                    .truncationMode(.tail)
                                    .font(.system(size: 20))
                                    //.foregroundColor(isProgressRoll ? .gray : .black)
                                Button {
                                    rerollActionDice()
                                } label: {
                                    Text(actionDie == 0 ? "?" : "\(actionDie)")
                                        .onReceive(timer) { time in
                                            if whatIsRoll == "all" || whatIsRoll == "action" {
                                                if self.isTimerRunning { actionDie = Int.random(in: 1...6)}
                                            }
                                        }
                                    
                                } .buttonStyle(HSSButtons())
                                    .font(.system(size: 60))
                                    .disabled(textOnRollButton == "ROLL" ? true : false)
                                    .rotationEffect(.degrees(whatIsRoll == "all" || whatIsRoll == "action" ? spinning : 0))
                                    .animation(.linear(duration: whatIsRoll == "all" || whatIsRoll == "action" ? animationTime : 0), value: whatIsRoll == "all" || whatIsRoll == "action" ? spinning : 0)
                            }
                            VStack {
                                Text("Modifier")
                                    .truncationMode(.middle)
                                    .font(.system(size: 20))
                                Button {} label: {
                                    Text(modifier >= 0 ? "+\(modifier)" : "\(modifier)")
                                } .buttonStyle(HSSButtons())
                                    .font(.system(size: 60))
                                    .disabled(true)
                                
                            }
                            VStack {
                                Text(NSLocalizedString("\(statName)", comment: ""))
                                    .font(.system(size: 20))
                                Button {} label: {
                                    Text("+\(statValue)")
                                } .buttonStyle(HSSButtons())
                                    .font(.system(size: 60))
                                    .disabled(true)
                            }
                        }
                        .padding(.horizontal, 10)
                        HStack {
                            Stepper("mod") {
                                modifier += 1
                            } onDecrement: {
                                modifier -= 1
                            } .labelsHidden()
                                .padding(.bottom, 10)
                                .padding()
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                    .padding(.top, -70)
                }
                VStack {
                    if isProgressRoll && selectedRollType == 0 {
                        Text(statName).font(.system(size: 40))
                    }
                    Button {
                        rollTheDice()
                    } label: {
                        Text(NSLocalizedString(self.textOnRollButton, comment: ""))
                    }
                    .truncationMode(.middle)
                    .frame(width: 280)
                    .font(.system(size: 40))
                    .padding(5)
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .cornerRadius(7)
                    .padding(.bottom, -20)
                    
                    Text(actionRoll == 90 ? "..." : "\(actionRoll)")
                        .font(.system(size: 90))
                        .fontWeight(.semibold)
                        .padding(.bottom, 7)
                        
                    
                }
                HStack {
                    Spacer(minLength: 40)
                    Button {
                        rerollChallenge1()
                    } label: {
                        Text(challengeDie1 == -1 ? "?" : "\(challengeDie1)")
                            .onReceive(timer) { time in
                                if whatIsRoll == "all" || whatIsRoll == "challenge1" {
                                    if self.isTimerRunning { challengeDie1 = Int.random(in: 1...10)}
                                }
                            }
                            .foregroundColor(match ? .yellow : .white)
                    } .buttonStyle(HSSButtons())
                        .frame(maxWidth: 130)
                        .font(.system(size: 60))
                        .disabled(textOnRollButton == "ROLL" ? true : false)
                        .rotationEffect(.degrees(whatIsRoll == "all" || whatIsRoll == "challenge1" ? spinning : 0))
                        .animation(.linear(duration: whatIsRoll == "all" || whatIsRoll == "challenge1" ? animationTime : 0), value: whatIsRoll == "all" || whatIsRoll == "challenge1" ? spinning : 0)
                    
                    Spacer(minLength: 40)
                    Button {
                        rerollChallenge2()
                    } label: {
                        Text(challengeDie2 == -1 ? "?" : "\(challengeDie2)")
                            .onReceive(timer) { time in
                                if whatIsRoll == "all" || whatIsRoll == "challenge2" {
                                    if self.isTimerRunning { challengeDie2 = Int.random(in: 1...10)}
                                }
                            }
                            .foregroundColor(match ? .yellow : .white)
                    } .buttonStyle(HSSButtons())
                        .frame(maxWidth: 130)
                        .font(.system(size: 60))
                        .disabled(textOnRollButton == "ROLL" ? true : false)
                        .rotationEffect(.degrees(whatIsRoll == "all" || whatIsRoll == "challenge2" ? spinning : 0))
                        .animation(.linear(duration: whatIsRoll == "all" || whatIsRoll == "challenge2" ? animationTime : 0), value: whatIsRoll == "all" || whatIsRoll == "challenge2" ? spinning : 0)
                    Spacer(minLength: 40)
                }
                
                Button {
                    hero.stats.momentum = hero.stats.resetMomentum
                    if self.burneDice1 == true {challengeDie1 = 0}
                    if self.burneDice2 == true {challengeDie2 = 0}
                    textOnRollButton = "\(burneTo!)Hit"
                    burneTo = nil
                } label: {
                    if burneTo != "Strong " {
                        Text("Burne Momentum\nFor Hit")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20))
                    } else {
                        Text("Burne Momentum\nFor Strong Hit")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20))
                    }
                }
                .padding()
                .frame(width: 200)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(.top, 20)
                .opacity(burneTo != nil ? 1 : 0)

                Spacer()
                
                Picker(selection: $selectedRollType.animation(), label: Text("type")) {
                    if isProgressRoll {
                        ForEach(RollType2.indices, id: \.self) { type in
                            Text(RollType2[type])
                        }
                    } else {
                        ForEach(RollType1.indices, id: \.self) { type in
                            Text(NSLocalizedString(RollType1[type], comment: ""))
                        }
                    }
                } .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .onChange(of: self.selectedRollType) { newValue in
                        match = false
                        actionDie = 0
                        actionRoll = 90
                        challengeDie2 = -1
                        challengeDie1 = -1
                        textOnRollButton = "ROLL"
                        burneTo = nil//??
                    }
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:0.3)))
                               
            }
        }
    }
    func rollTheDice() {
        self.playSound(sound: "dice", type: "mp3")
        whatIsRoll = "all"
        self.match = false
        self.burneTo = nil
        self.isTimerRunning = true
        spinning += 1080
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.isTimerRunning = false
            if selectedRollType == 0 {
                getActionRollResult()
            }
            if selectedRollType == 1 {
                getOracleRollresult()
            }
        }
    }
    
    func rerollActionDice() {
        self.playSound(sound: "dice", type: "mp3")
        whatIsRoll = "action"
        self.isTimerRunning = true
        spinning += 1080
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.isTimerRunning = false
            if selectedRollType == 0 {
                getActionRollResult()
            }
            if selectedRollType == 1 {
                getOracleRollresult()
            }
        }
    }
    func rerollChallenge1() {
        self.playSound(sound: "dice", type: "mp3")
        whatIsRoll = "challenge1"
        self.isTimerRunning = true
        spinning += 1080
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.isTimerRunning = false
            if selectedRollType == 0 {
                getActionRollResult()
            }
            if selectedRollType == 1 {
                getOracleRollresult()
            }
        }
    }
    func rerollChallenge2() {
        playSound(sound: "dice", type: "mp3")
        whatIsRoll = "challenge2"
        self.isTimerRunning = true
        spinning += 1080
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.isTimerRunning = false
            if selectedRollType == 0 {
                getActionRollResult()
            }
            if selectedRollType == 1 {
                getOracleRollresult()
            }
        }
    }
    
    func getActionRollResult() {
        // Get values
        if whatIsRoll == "all" {
            self.challengeDie1 = Int.random(in: 1...10)
            self.challengeDie2 = Int.random(in: 1...10)
            self.actionDie = Int.random(in: 1...6)
        }
        if whatIsRoll == "action" {
            self.actionDie = Int.random(in: 1...6)
        }
        if whatIsRoll == "challenge1" {
            self.challengeDie1 = Int.random(in: 1...10)
        }
        if whatIsRoll == "challenge2" {
            self.challengeDie2 = Int.random(in: 1...10)
        }

        if challengeDie1 == challengeDie2 {match = true}
        // Summ values
        if !isProgressRoll {
            self.actionRoll = actionDie + statValue + modifier
        } else {
            self.actionRoll = statValue
        }
        
        // For Strong Hit
        if actionRoll > challengeDie1 && actionRoll > challengeDie2 {
            self.textOnRollButton = results.strongHit.rawValue
        }
        // For Miss
        else if actionRoll <= challengeDie1 && actionRoll <= challengeDie2 {
            self.textOnRollButton = results.miss.rawValue
            // Burne
            if !isProgressRoll {
                if hero.stats.momentum > challengeDie1 && hero.stats.momentum > challengeDie2 { burne(hit: "Strong ", die: "all") }
                else if hero.stats.momentum > challengeDie1 { burne(hit: "", die: "challengeDie1") }
                else if hero.stats.momentum > challengeDie2 { burne(hit: "", die: "challengeDie2") }
            }
        }
        // For Hit
        else if actionRoll > challengeDie1 || actionRoll > challengeDie2 {
            self.textOnRollButton = results.hit.rawValue
            // Burne
            if !isProgressRoll {
                if actionRoll > challengeDie1 && hero.stats.momentum > challengeDie2 { burne(hit: "Strong ", die: "challengeDie2") }
                else if actionRoll > challengeDie2 && hero.stats.momentum > challengeDie1 { burne(hit: "Strong ", die: "challengeDie1") }
            }
        }
        //self.rollButton.isUserInteractionEnabled = false
        //отключение кнопки после броска
    }
    
    func burne(hit: String, die: String) {
        if die == "challengeDie1" {self.burneDice1 = true}
        if die == "challengeDie2" {self.burneDice2 = true}
        if die == "all" {
            self.burneDice1 = true
            self.burneDice2 = true
        }
        self.burneTo = hit
    }
    
    func getOracleRollresult() {
        self.challengeDie1 = Int.random(in: 0...9)
        self.challengeDie2 = Int.random(in: 0...9)
        if self.challengeDie1 == self.challengeDie2 {
            match = true
        }
        var sum = Int(String(self.challengeDie1) + String(self.challengeDie2))
        if sum == 00 {sum = 100}
        self.actionRoll = sum ?? 00
    }
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR")
            }
        }
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView(hero: Hero(), isProgressRoll: false, statName: "test", statValue: 0)
    }
}
