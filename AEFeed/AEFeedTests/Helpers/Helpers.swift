//
//  Helpers.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation
import AEFeed

public func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

public func anyNSError() -> NSError {
    return NSError(domain: "any-error", code: 1)
}

public func anyData() -> Data {
    return Data("any data".utf8)
}

public extension FeedImage {
    var url: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500/")!.appendingPathComponent(imagePath)
    }
}

public extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
