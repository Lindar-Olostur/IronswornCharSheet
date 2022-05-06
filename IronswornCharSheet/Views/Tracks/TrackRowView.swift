//
//  VowRowView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 01.04.2022.
//

import SwiftUI

struct TrackRowView: View {
    @EnvironmentObject var hero: Hero
    @State var track: Track
    @State var isHidden = true
    @Binding var valueForRoll: Int
    @Binding var valueNameForRoll: String
    @Binding var openedRollView: Bool
    
    var trackIndex: Int {
        hero.stats.tracks.firstIndex(where: { $0.id == $track.id})!
    }
    
    var body: some View {
        VStack {
            VStack {
                //HEADER
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(NSLocalizedString(track.name, comment: "")) \(track.role)")
                            .font(.system(size: 25))
                            .foregroundColor(track.forsaken ? .gray : (track.fullfilled ? .black : .blue))
                            .bold()
                            .strikethrough(track.forsaken ? true : false)
                        if track.type != "Legacy" {
                            Text(NSLocalizedString(String(track.rankList[track.rank]), comment: ""))
                                .foregroundColor(.gray)
                        }
                        else {
                            Text("Experience to spend: \((track.legacyExp-track.legXpForSpend))")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    if track.fullfilled {
                        Image(systemName: "checkmark.seal")
                            .font(.title)
                    }
                    if !track.fullfilled && !track.forsaken {
                        Button(action: {
                            if !track.legacy10Up {
                                valueForRoll = Int(track.currentProgress)
                            } else {
                                valueForRoll = 10 + Int(track.currentLegacyProgress)
                            }
                            valueNameForRoll = track.name
                            openedRollView = true
                        }, label: {
                            if !track.legacy10Up {
                                Text("\(Int(track.currentProgress.rounded(.down)))")
                            } else {
                                Text("\(Int(ceil(track.currentProgress))+(Int(track.currentLegacyProgress.rounded(.down))))")
                            }
                        })
                        .buttonStyle(HSSButtons())
                        .font(.system(size: 25))
                        .frame(width: 80)
                    }
                    Button {
                        isHidden.toggle()
                    } label: {
                        Image(systemName: !isHidden ? "chevron.right" : "chevron.down")
                    }
                    .padding(.trailing)
                }
            }
            
            //PROGRESS BAR
            //            VStack {
            //                ProgressBar(value: $vow.currentProgress).frame(height: 30)
            //                Button("+1") {
            //                    vow.currentProgress += 3.0
            //                }
            //            }.padding()
            
            if isHidden == true {
                VStack(alignment: .leading) {
                    //BOXES
                    if track.legacy10Up {
                        HStack {
                            ForEach(0..<Int(track.currentLegacyProgress), id: \.self) {_ in
                                ZStack {
                                    Image(systemName: "square.split.diagonal.2x2")
                                        .font(.title)
                                        .padding(-3)
                                    Image(systemName: "square.split.2x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                            }
                            ForEach(0..<1) {_ in
                                if track.currentLegacyProgress - Double(Int(track.currentLegacyProgress)) == 0.25 {
                                    Image(systemName: "square.split.1x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                                if track.currentLegacyProgress - Double(Int(track.currentLegacyProgress)) == 0.5 {
                                    Image(systemName: "square.split.2x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                                if track.currentLegacyProgress - Double(Int(track.currentLegacyProgress)) == 0.75 {
                                    ZStack {
                                        Image(systemName: "square.split.2x2")
                                            .font(.title)
                                            .padding(-3)
                                        Image(systemName: "square.split.diagonal")
                                            .font(.title)
                                            .padding(-3)
                                    }
                                }
                            }
                            ForEach(0..<(10-Int(ceil(track.currentLegacyProgress))), id: \.self) {_ in
                                Image(systemName: "square")
                                    .font(.title)
                                    .padding(-3)
                            }
                        }
                        .padding(.vertical)
                    } else {
                        HStack {
                            ForEach(0..<Int(track.currentProgress), id: \.self) {_ in
                                ZStack {
                                    Image(systemName: "square.split.diagonal.2x2")
                                        .font(.title)
                                        .padding(-3)
                                    Image(systemName: "square.split.2x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                            }
                            ForEach(0..<1) {_ in
                                if track.currentProgress - Double(Int(track.currentProgress)) == 0.25 {
                                    Image(systemName: "square.split.1x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                                if track.currentProgress - Double(Int(track.currentProgress)) == 0.5 {
                                    Image(systemName: "square.split.2x2")
                                        .font(.title)
                                        .padding(-3)
                                }
                                if track.currentProgress - Double(Int(track.currentProgress)) == 0.75 {
                                    ZStack {
                                        Image(systemName: "square.split.2x2")
                                            .font(.title)
                                            .padding(-3)
                                        Image(systemName: "square.split.diagonal")
                                            .font(.title)
                                            .padding(-3)
                                    }
                                }
                            }
                            ForEach(0..<(10-Int(ceil(track.currentProgress))), id: \.self) {_ in
                                Image(systemName: "square")
                                    .font(.title)
                                    .padding(-3)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    
                    //STEPPER
                    if !track.fullfilled && !track.forsaken {
                        HStack{
                            Stepper {
                                Text("Progress: \(Int(track.currentLegacyProgress.rounded(.down)) + Int(track.currentProgress.rounded(.down)))/10")
                                    .font(.system(size: 20))
                            } onIncrement: {
                                if track.legacy10Up {
                                    if  hero.stats.tracks[trackIndex].currentLegacyProgress > 10 {
                                        hero.stats.tracks[trackIndex].currentLegacyProgress = 10
                                    } else {
                                        hero.stats.tracks[trackIndex].currentLegacyProgress += hero.stats.tracks[trackIndex].stepList[track.rank]
                                    }
                                } else {
                                    if  hero.stats.tracks[trackIndex].currentProgress > 10 {
                                        hero.stats.tracks[trackIndex].currentProgress = 10
                                    } else {
                                        hero.stats.tracks[trackIndex].currentProgress += hero.stats.tracks[trackIndex].stepList[track.rank]
                                    }
                                }
                            } onDecrement: {
                                if track.legacy10Up {
                                    if hero.stats.tracks[trackIndex].currentLegacyProgress < 0 {
                                        hero.stats.tracks[trackIndex].currentLegacyProgress = 0
                                    } else {
                                        hero.stats.tracks[trackIndex].currentLegacyProgress -= hero.stats.tracks[trackIndex].stepList[track.rank]
                                    }
                                } else {
                                    if hero.stats.tracks[trackIndex].currentProgress < 0 {
                                        hero.stats.tracks[trackIndex].currentProgress = 0
                                    } else {
                                        hero.stats.tracks[trackIndex].currentProgress -= hero.stats.tracks[trackIndex].stepList[track.rank]
                                    }
                                }
                            }
                        }
                    }
                    if track.type == "Legacy" {
                        Stepper("Experience: \(track.legXpForSpend)/\(track.legacyExp)", value: $hero.stats.tracks[trackIndex].legXpForSpend, in: 0...track.legacyExp)
                            .padding(.top)
                            .font(.system(size: 20))
                    }
                    if track.type != "Legacy" {
                        Text("Description")
                        
                        Divider()
                        if !track.fullfilled {
                            Toggle("Forsaken", isOn: $track.forsaken.animation(.spring()))
                        }
                        if !track.forsaken {
                            Toggle("Fullfilled", isOn: $track.fullfilled.animation(.spring()))
                        }
                    }
                    
                }
            }
            Spacer()
        }
    }
}

//struct ProgressBar: View {
//    @Binding var value: Double
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
//                    .opacity(0.3)
//                    .foregroundColor(Color(UIColor.systemTeal))
//
//                Rectangle().frame(width: min(CGFloat(self.value/10)*geometry.size.width, geometry.size.width), height: geometry.size.height)
//                    .foregroundColor(Color(UIColor.systemBlue))
//                    .animation(.spring(), value: value)
//
//                Text(String(format: "%.2f", value))
//                    .padding(.leading, 300)
//            }.cornerRadius(45.0)
//        }
//    }
//}

struct VowRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrackRowView(track: Track(type: "Legacy"), valueForRoll: .constant(0), valueNameForRoll: .constant("Track Name"), openedRollView: .constant(false))
            .environmentObject(Hero())
        
    }
}
