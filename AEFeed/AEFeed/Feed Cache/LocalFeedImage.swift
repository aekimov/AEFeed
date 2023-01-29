//
//  LocalFeedItem.swift
//  AEFeed
//
//  Created by Artem Ekimov on 11/4/22.
//

import Foundation

public struct LocalFeedImage: Equatable {
    public let id: Int
    public let title: String
    public let imagePath: String
    public let overview: String
    
    public init(id: Int, title: String, imagePath: String, overview: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.overview = overview
    }
}

public struct LocalFeed {
    public let items: [LocalFeedImage]
    public let page: Int
    
    public init(items: [LocalFeedImage], page: Int) {
        self.items = items
        self.page = page
    }
}
