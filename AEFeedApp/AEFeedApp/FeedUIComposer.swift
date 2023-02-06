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
import Foundation

public class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> ListViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: { feedLoader().dispatchOnMainQueue() })
        
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let viewController = ListViewController(refreshController: refreshController)
        let presenter = FeedPresenter(feedView: FeedViewAdapter(controller: viewController,
                                                                imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
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
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let imageBaseURL: URL
    private var cancellable: Cancellable?
    
    var imagePresenter: FeedImagePresenter<View, Image>?

    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher, imageBaseURL: URL) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageBaseURL = imageBaseURL
    }
    
    func didRequestImage() {
        imagePresenter?.didStartLoadingImageData(for: model)
        let model = self.model
        
        cancellable = imageLoader(composeURL(for: model)).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.imagePresenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }, receiveValue: { [weak self] data in
            self?.imagePresenter?.didFinishLoadingImageData(with: data, for: model)
        })
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
    
    private func composeURL(for model: FeedImage) -> URL {
        return imageBaseURL.appendingPathComponent(model.imagePath)
    }

}

private final class FeedViewAdapter: FeedView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: ListViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
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
