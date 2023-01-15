//
//  FeedCacheTestHelpers.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 1/15/23.
//

import Foundation
import AEFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID().hashValue, title: "any", imagePath: "/any-path")
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, title: $0.title, imagePath: $0.imagePath) }
    return (models, local)
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
