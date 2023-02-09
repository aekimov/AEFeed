//
//  FeedImagePresenter.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

import Foundation

public final class FeedImagePresenter {
    
    public static func map(_ model: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(title: model.title, overview: model.overview)
    }
}
