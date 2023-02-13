//
//  Paginated.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/13/23.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Swift.Result<Self, Swift.Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
