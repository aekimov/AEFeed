//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/29/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                let image = try ManagedFeedImage.first(with: url.lastPathComponent, in: context)
                image?.data = data
                try context.save()
            })
        }
    }

    public func retrieve(dataFor url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                return try ManagedFeedImage.data(with: url, in: context)
            })
        }
    }

}
