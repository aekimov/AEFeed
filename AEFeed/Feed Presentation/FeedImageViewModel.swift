//
//  FeedImageViewModel.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let title: String
    public let overview: String
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
}
