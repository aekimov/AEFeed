//
//  FeedImagePresenterTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 1/27/23.
//

import XCTest
import AEFeed

class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.title, image.title)
        XCTAssertEqual(viewModel.overview, image.overview)

    }
}
