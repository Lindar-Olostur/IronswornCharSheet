//
//  test.swift
//  IronswornCharSheet
//
//  Created by Lindar Olostur on 24.03.2022.
//

import SwiftUI

struct test: View {
    var asset: Asset
    var body: some View {
        VStack {
            Text(asset.name)
            Text(asset.firstRankText)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test(asset: Asset(name: "Космический корабль", rank: 3, firstRankText: "Твой вооруженный многоцелевой космолет подходит как для межзвездных так и внутри атмосферных перелетов. Он может с комфортом перевозить несколько человек, имеет место для груза, а также может нести и запускать вспомогательный странспорт. Когда ты Развиваешься, ты можешь потратить опыт на оснащение этого корабля дополнительными модулями.", secondRankText: "Когда ты Завершаешь экспедицию (опасную или выше) и добиваешься супеха, это путешествие усиливает твою связь со своим кораблем и союзниками на ботру. Ты и твои союзники могут отметить 1 тик на своей шкале связей.", thirdRankText: "Когда ты Выдерживаешь повреждения, ты можешь бросить +нрав. Делая так, Получи стресс(-1) в случае частичного успеха или провала.", status: "Состояние: исправен", statIsEnabled: true, statName: "Прочность", statMax: 5, statCurrent: 5))
    }
}
