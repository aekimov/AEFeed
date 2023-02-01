//
//  FeedImageDataCache.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/1/23.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
