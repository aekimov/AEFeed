//
//  ListUIIntegrationTests+Assert.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 2/12/23.
//

import XCTest
import AEFeediOS
import AEFeed

extension ListUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        sut.tableView.enforceLayoutUpdate()
        
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
        }

        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.titleText, image.title, "Expected location text to be \(String(describing: image.title)) for image  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.overviewText, image.overview, "Expected description text to be \(String(describing: image.overview)) for image view at index (\(index)", file: file, line: line)
    }

}
