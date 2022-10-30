//
//  Helpers.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
public func anyNSError() -> NSError {
    return NSError(domain: "any-error", code: 1)
}
