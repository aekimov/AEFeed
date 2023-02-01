//
//  AEFeedAppUIAcceptanceTests.swift
//  AEFeedAppUIAcceptanceTests
//
//  Created by Artem Ekimov on 2/1/23.
//

import XCTest

final class AEFeedAppUIAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()

        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 5)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)
    }
}
