//
//  CacheFeedUseCaseTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 11/1/22.
//

import XCTest


class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
    
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
