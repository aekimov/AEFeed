//
//  CoreDataFeedStore+FeedStore.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/29/23.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.find(in: context).map {
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }))
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result(catching: {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            }))
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.deleteCache(in: context)
            }))
        }
    }
}
