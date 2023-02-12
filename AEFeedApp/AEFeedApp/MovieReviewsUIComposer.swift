//
//  MovieReviewsUIComposer.swift
//  AEFeedApp
//
//  Created by Artem Ekimov on 2/12/23.
//

import UIKit
import AEFeed
import AEFeediOS
import Combine
import Foundation

public class MovieReviewsUIComposer {
    private init() {}
    
    public static func reviewsComposedWith(reviewsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: reviewsLoader)
        
        let refreshController = RefreshViewController(onRefresh: presentationAdapter.loadResource)
        let viewController = ListViewController(refreshController: refreshController)
        
        let presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: viewController, imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher() }),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(viewController),
            mapper: FeedPresenter.map)

        viewController.title = MovieReviewsPresenter.title
        presentationAdapter.presenter = presenter
        return viewController
    }
}
