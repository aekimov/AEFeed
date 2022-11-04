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
    
    public init(id: Int, title: String, imagePath: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
    }
}
