//
//  Helpers.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 1/30/23.
//

import Foundation
import AEFeed
import XCTest

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID().hashValue, title: "any", imagePath: "\(UUID().hashValue)", overview: "any overview")]
}

extension FeedImage {
    var url: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500/")!.appendingPathComponent(imagePath)
    }
}


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
