//
//  FeedImage.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/29/22.
//

import Foundation

public struct FeedImage: Equatable {
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

public struct MoviesFeed: Equatable {
    public let items: [FeedImage]
    public let page: Int
    
    public init(items: [FeedImage], page: Int) {
        self.items = items
        self.page = page
    }
}


