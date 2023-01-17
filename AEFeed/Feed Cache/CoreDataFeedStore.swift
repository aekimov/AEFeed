//
//  CoreDataFeedStore.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/17/23.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    public init() {}

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }

}

private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var imagePath: String
    @NSManaged var cache: ManagedCache
}
