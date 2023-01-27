//
//  FeedLoadingViewModel.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}
