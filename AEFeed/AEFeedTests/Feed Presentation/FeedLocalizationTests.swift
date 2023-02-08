//
//  FeedLocalizationTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 1/22/23.
//

import XCTest
import AEFeed

final class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKyeAndValuesExist(in: bundle, table)
    }
}
