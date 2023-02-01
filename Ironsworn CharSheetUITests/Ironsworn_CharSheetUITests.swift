//
//  Ironsworn_CharSheetUITests.swift
//  Ironsworn CharSheetUITests
//
//  Created by Lindar Olostur on 02.12.2022.
//

import XCTest

final class Ironsworn_CharSheetUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        //UserDefaults.standard.set("Named a", forKey: "lastHero")
        app = XCUIApplication()
        app.launch()
    }


    func testExample() throws {
        //-------
        
        
        let edgeButton = app.buttons["Edge"]
//        let shadowButton = app.buttons.element.label["Shadow"]
        XCTAssertTrue(edgeButton.exists)
                
        edgeButton.tap()
        
        print("lol")
        
                
                  
        app.terminate()
    }

}
