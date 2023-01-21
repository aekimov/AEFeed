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
        
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: viewController, loader: imageLoader)
        return viewController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: ListViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.models = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
