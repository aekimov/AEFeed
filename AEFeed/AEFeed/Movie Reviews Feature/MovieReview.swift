//
//  MovieReview.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/7/23.
//

import Foundation

public struct MovieReview: Equatable {
    public let id: String
    public let author: String
    public let content: String
    public let createdAt: Date
    
    public init(id: String, author: String, content: String, createdAt: Date) {
        self.id = id
        self.author = author
        self.content = content
        self.createdAt = createdAt
    }
}
