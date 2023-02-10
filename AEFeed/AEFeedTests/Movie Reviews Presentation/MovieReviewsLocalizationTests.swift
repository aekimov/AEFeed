//
//  MovieReviewsLocalizationTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 2/10/23.
//

import XCTest
import AEFeed

final class MovieReviewsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "MovieReviews"
        let bundle = Bundle(for: MovieReviewsPresenter.self)
        
        assertLocalizedKyeAndValuesExist(in: bundle, table)
    }
}
