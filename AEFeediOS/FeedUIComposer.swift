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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let viewController = ListViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: viewController, imageLoader: imageLoader)
        
        return viewController
    }

}

private final class FeedViewAdapter: FeedView {
    private weak var controller: ListViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: ListViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(feed: [FeedImage]) {
        controller?.models = feed.map { model in
            let viewModel = FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: viewModel)
        }
    }
}
