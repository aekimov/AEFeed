//
//  FeedUIComposer.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import UIKit
import AEFeed
import AEFeediOS
import Combine

public class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: FeedImageDataLoader) -> ListViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: { feedLoader().dispatchOnMainQueue() })
        
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let viewController = ListViewController(refreshController: refreshController)
        let presenter = FeedPresenter(feedView: FeedViewAdapter(controller: viewController,
                                                                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
                                      loadingView: WeakRefVirtualProxy(refreshController),
                                      errorView: WeakRefVirtualProxy(viewController))
        viewController.title = FeedPresenter.title
        presentationAdapter.presenter = presenter
        return viewController
    }
}

final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let feedLoader: () -> FeedLoader.Publisher
    private var cancellable: Cancellable?
    var presenter: FeedPresenter?

    init(feedLoader: @escaping () -> FeedLoader.Publisher) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        cancellable = feedLoader().sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }, receiveValue: { [weak self] feed in
            self?.presenter?.didFinishLoadingFeed(with: feed)
        })
    }
}

private final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where Image == View.Image {
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageBaseURL: URL
    
    var imagePresenter: FeedImagePresenter<View, Image>?

    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageBaseURL: URL) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageBaseURL = imageBaseURL
    }
    
    func didRequestImage() {
        imagePresenter?.didStartLoadingImageData(for: model)
        let model = self.model
        
        task = imageLoader.loadImageData(from: composeURL(for: model)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imagePresenter?.didFinishLoadingImageData(with: data, for: model)
            case .failure(let error):
                self?.imagePresenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
        task = nil
    }
    
    private func composeURL(for model: FeedImage) -> URL {
        return imageBaseURL.appendingPathComponent(model.imagePath)
    }

}

private final class FeedViewAdapter: FeedView {
    private weak var controller: ListViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: ListViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader, imageBaseURL: imageBaseURL)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.imagePresenter = FeedImagePresenter(view: WeakRefVirtualProxy(view),
                                                        imageTransformer: UIImage.init)
            
            return view
        })
    }
}
