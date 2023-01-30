//
//  Helpers.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 1/30/23.
//

import Foundation
import XCTest

public func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

public func anyData() -> Data {
    return Data("any data".utf8)
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
