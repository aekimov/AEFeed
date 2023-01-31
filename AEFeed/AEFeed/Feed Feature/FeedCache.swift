//
//  FeedCache.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/31/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
