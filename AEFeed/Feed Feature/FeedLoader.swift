//
//  FeedLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<MoviesFeed, Error>
    func load(_ req: URL, completion: @escaping (Result) -> Void)
}
