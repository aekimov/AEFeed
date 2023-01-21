//
//  FeedViewModel.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import AEFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?

    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
