//
//  FeedViewModel.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}
