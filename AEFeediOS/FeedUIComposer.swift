//
//  FeedUIComposer.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import UIKit
import AEFeed

public class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> ListViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let viewController = ListViewController(refreshController: refreshController)
        
        refreshController.onRefresh = { [weak viewController] feed in
            viewController?.models = feed.map { model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            }
        }
        return viewController
    }
}
