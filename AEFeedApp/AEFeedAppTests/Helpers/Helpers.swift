//
//  Helpers.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 1/30/23.
//

import Foundation

public func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
