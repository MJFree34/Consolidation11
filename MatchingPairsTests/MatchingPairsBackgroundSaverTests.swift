//
//  MatchingPairsBackgroundSaverTests.swift
//  MatchingPairsTests
//
//  Created by Matt Free on 5/29/20.
//  Copyright © 2020 Matt Free. All rights reserved.
//

import XCTest
@testable import MatchingPairs

class MatchingPairsBackgroundSaverTests: XCTestCase {
    var backgroundSaver: BackgroundSaver!
    var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        defaults = UserDefaults.makeClearedInstance()
        defaults.removePersistentDomain(forName: #file)
        
        backgroundSaver = BackgroundSaver(defaults: defaults)
    }

    override func tearDown() {
        backgroundSaver = nil
        defaults = nil
        super.tearDown()
    }
    
    func testResizesBackgroundsWithPhone() {
        measure {
            backgroundSaver.resizeBackgrounds(viewBounds: CGRect(x: 0, y: 0, width: 414, height: 896))
            defaults = UserDefaults.makeClearedInstance()
            defaults.removePersistentDomain(forName: #file)
        }
    }
    
    func testResizesBackgroundsWithPad() {
        measure {
            backgroundSaver.resizeBackgrounds(viewBounds: CGRect(x: 0, y: 0, width: 810, height: 1080))
            defaults = UserDefaults.makeClearedInstance()
            defaults.removePersistentDomain(forName: #file)
        }
    }
    
    func testDoesNotResizeBackgroundsWhenTheyExist() {
        // given
        let viewBounds = CGRect(x: 0, y: 0, width: 414, height: 896)
        let greenData = renderImage(backgroundName: "GreenBackground", viewBounds: viewBounds)
        let blueData = renderImage(backgroundName: "BlueBackground", viewBounds: viewBounds)
        let redData = renderImage(backgroundName: "RedBackground", viewBounds: viewBounds)
        
        // when
        defaults.set(greenData, forKey: "GreenBackground")
        defaults.set(blueData, forKey: "BlueBackground")
        defaults.set(redData, forKey: "RedBackground")
        defaults.set("blue", forKey: "Background")
        backgroundSaver.resizeBackgrounds(viewBounds: viewBounds)
        defaults.set("red", forKey: "Background")
        backgroundSaver.resizeBackgrounds(viewBounds: viewBounds)
        
        // then
        XCTAssertNil(defaults.data(forKey: "PinkBackground"))
        XCTAssertNotEqual(UIImage(data: greenData), backgroundSaver.currentBackground)
        XCTAssertNotEqual(UIImage(data: blueData), backgroundSaver.currentBackground)
        XCTAssertEqual(backgroundSaver.currentBackgroundColor(), "red")
    }
    
    func renderImage(backgroundName: String, viewBounds: CGRect) -> Data {
        let render = UIGraphicsImageRenderer(size: CGSize(width: viewBounds.width, height: viewBounds.height))
        
        let image = render.image { (context) in
            let background = UIImage(named: backgroundName)!
            
            background.draw(in: CGRect(x: -50, y: -50, width: viewBounds.width + 100, height: viewBounds.height + 100))
        }
        
        let imageData = image.jpegData(compressionQuality: 0.5)!
        
        return imageData
    }
}
