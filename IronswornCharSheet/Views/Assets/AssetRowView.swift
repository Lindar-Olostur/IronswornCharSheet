//
//  AssetRowView.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 23.03.2022.
//

import SwiftUI

struct AssetRowView: View {
    @EnvironmentObject var hero: Hero
    @State var isHidden = true
    @State var asset: Asset
    var assetIndex: Int {
        hero.stats.assets.firstIndex(where: { $0.id == $asset.id})!
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(asset.name)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .bold()
                    if asset.status != "" {
                        Text(asset.status)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "star.fill")
                if asset.rank > 1 {Image(systemName: "star.fill")}
                if asset.rank > 2 {Image(systemName: "star.fill")}
                Button {
                    isHidden.toggle()
                } label: {
                    Image(systemName: !isHidden ? "chevron.right" : "chevron.down")
                }
                .padding(.trailing)
            }
            
            if isHidden == true {
                VStack(alignment: .leading) {
                    if asset.statIsEnabled {

                        HStack {
                            Text(asset.statName)
                                .bold()
                                .textCase(.uppercase)
                            Spacer()
                            Text("\(asset.statCurrent)")
                                .font(.system(size: 30))
                            Spacer()
                            Stepper("") {
                                if  hero.stats.assets[assetIndex].statCurrent >= hero.stats.assets[assetIndex].statMax {
                                    hero.stats.assets[assetIndex].statCurrent = hero.stats.assets[assetIndex].statMax
                                } else {
                                    hero.stats.assets[assetIndex].statCurrent += 1
                                }
                            } onDecrement: {
                                if  hero.stats.assets[assetIndex].statCurrent <= 0 {
                                    hero.stats.assets[assetIndex].statCurrent = 0
                                } else {
                                    hero.stats.assets[assetIndex].statCurrent -= 1
                                }
                            } .labelsHidden()
                        }
                    }
                    Text("\(asset.firstRankText)")
                        .padding(.top)
                    if asset.rank > 1 {
                        Text("\(asset.secondRankText)")
                            .padding(.top)
                    }
                    if asset.rank > 2 {
                        Text("\(asset.thirdRankText)")
                            .padding(.vertical)
                    }
                }
                .transition(.slide)
            }
            Spacer()
        }
        
        
    }
    
}

struct AssetRowView_Previews: PreviewProvider {
    static var previews: some View {
        AssetRowView(asset: Asset(name: "Космический корабль", rank: 3, firstRankText: "Твой вооруженный многоцелевой космолет подходит как для межзвездных так и внутри атмосферных перелетов. Он может с комфортом перевозить несколько человек, имеет место для груза, а также может нести и запускать вспомогательный странспорт. Когда ты Развиваешься, ты можешь потратить опыт на оснащение этого корабля дополнительными модулями.", secondRankText: "Когда ты Завершаешь экспедицию (опасную или выше) и добиваешься супеха, это путешествие усиливает твою связь со своим кораблем и союзниками на ботру. Ты и твои союзники могут отметить 1 тик на своей шкале связей.", thirdRankText: "Когда ты Выдерживаешь повреждения, ты можешь бросить +нрав. Делая так, Получи стресс(-1) в случае частичного успеха или провала.", status: "Состояние: исправен", statIsEnabled: true, statName: "Прочность", statMax: 5, statCurrent: 5))
    }
}
