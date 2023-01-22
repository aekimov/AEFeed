//
//  FeedImageViewModel.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import Foundation

struct FeedImageViewModel<Image> {
    let title: String
    let overview: String
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
}
