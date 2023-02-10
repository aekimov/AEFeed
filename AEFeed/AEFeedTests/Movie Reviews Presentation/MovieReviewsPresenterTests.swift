//
//  MovieReviewsPresenterTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 2/9/23.
//

import XCTest
import AEFeed

final class MovieReviewsPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(MovieReviewsPresenter.title, localized("MOVIE_REVIEWS_VIEW_TITLE"))
    }
  
    
    //MARK: - Helpers

    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "MovieReviews"
        let bundle = Bundle(for: MovieReviewsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

}
