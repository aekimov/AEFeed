//
//  FeedLoaderStub.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 1/31/23.
//

import AEFeed
import Foundation

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
