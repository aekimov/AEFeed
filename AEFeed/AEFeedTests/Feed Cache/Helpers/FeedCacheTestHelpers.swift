//
//  FeedCacheTestHelpers.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 1/15/23.
//

import Foundation
import AEFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID().hashValue, title: "any", imagePath: "\(UUID().hashValue)", overview: "any overview")
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, title: $0.title, imagePath: $0.imagePath, overview: $0.overview) }
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
