//
//  FeedItem.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/29/22.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: Int
    public let title: String
    public let imagePath: String
    
    public init(id: Int, title: String, imagePath: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
    }
}

public struct MoviesFeed: Equatable {
    public let items: [FeedItem]
    public let page: Int
    
    public init(items: [FeedItem], page: Int) {
        self.items = items
        self.page = page
    }
}


