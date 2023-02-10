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
  
    func test_map_createsViewModels() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        
        let comments = [
            MovieReview(id: "\(UUID().hashValue)", author: "an author", content: "any content", createdAt: now.adding(minutes: -10, calendar: calendar)),
            MovieReview(id: "\(UUID().hashValue)", author: "another author", content: "another content", createdAt: now.adding(days: -2, calendar: calendar))
        ]
        
        let viewModel = MovieReviewsPresenter.map(comments, currentDate: now, calendar: calendar, locale: locale)
        
        XCTAssertEqual(viewModel.reviews, [
            MovieReviewViewModel(author: "an author", content: "any content", date: "10 minutes ago"),
            MovieReviewViewModel(author: "another author", content: "another content", date: "2 days ago")
        ])
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
