//
//  FeedImagePresenter.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image

    func display(_ model: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: nil, isLoading: true, shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        let image = imageTransformer(data)
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: image, isLoading: false, shouldRetry: image == nil))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(title: model.title, overview: model.overview, image: nil, isLoading: false, shouldRetry: true))
    }
    
    public static func map(_ model: FeedImage) -> FeedImageViewModel<Image> {
        FeedImageViewModel(title: model.title, overview: model.overview, image: nil, isLoading: false, shouldRetry: false)
    }
}
