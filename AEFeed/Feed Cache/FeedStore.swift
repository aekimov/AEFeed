//
//  FeedStore.swift
//  AEFeed
//
//  Created by Artem Ekimov on 11/4/22.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

public struct LocalFeedItem: Equatable {
    public let id: Int
    public let title: String
    public let imagePath: String
    
    public init(id: Int, title: String, imagePath: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
    }
}
