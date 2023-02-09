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
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: feedLoader)
        
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let viewController = ListViewController(refreshController: refreshController)
        
        let presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: viewController, imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(viewController),
            mapper: FeedPresenter.map)

        viewController.title = FeedPresenter.title
        presentationAdapter.presenter = presenter
        return viewController
    }
}

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?

    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            }, receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            })
    }
}

extension LoadResourcePresentationAdapter: FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh() {
        loadResource()
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: ListViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let imageBaseURL = self.imageBaseURL
            
            let adapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>(
                loader: { [imageLoader] in
                    let url = imageBaseURL.appendingPathComponent(model.imagePath)
                    return imageLoader(url)
                })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter<FeedImageCellController, UIImage>.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: { data in
                    guard let image = UIImage(data: data) else { throw InvalidImageData() }
                    return image
                })
            
            return view
        })
    }
    
    private func composeURL(for model: FeedImage) -> URL {
        return imageBaseURL.appendingPathComponent(model.imagePath)
    }
}

private struct InvalidImageData: Error {}

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where Image == View.Image {
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
        
        cancellable = imageLoader(composeURL(for: model))
            .dispatchOnMainQueue()
            .sink(receiveCompletion: { [weak self] completion in
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
        cancellable = nil
    }
    
    private func composeURL(for model: FeedImage) -> URL {
        return imageBaseURL.appendingPathComponent(model.imagePath)
    }

}
