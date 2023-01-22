//
//  FeedImagePresenter.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import AEFeed
import Foundation

protocol FeedImageView {
    associatedtype Image

    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where Image == View.Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: nil, isLoading: true, shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
            return
        }
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: image, isLoading: false, shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: nil, isLoading: false, shouldRetry: true))
    }
    
}
