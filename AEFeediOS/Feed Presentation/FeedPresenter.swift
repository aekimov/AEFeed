//
//  FeedPresenter.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import AEFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
