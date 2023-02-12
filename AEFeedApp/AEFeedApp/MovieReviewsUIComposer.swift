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
    
    public static func reviewsComposedWith(reviewsLoader: @escaping () -> AnyPublisher<[MovieReview], Error>) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[MovieReview], MovieReviewsViewAdapter>(loader: reviewsLoader)
        
        let refreshController = RefreshViewController(onRefresh: presentationAdapter.loadResource)
        let viewController = ListViewController(refreshController: refreshController)
        
        let presenter = LoadResourcePresenter(
            resourceView: MovieReviewsViewAdapter(controller: viewController),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(viewController),
            mapper: { MovieReviewsPresenter.map($0) })

        viewController.title = MovieReviewsPresenter.title
        presentationAdapter.presenter = presenter
        return viewController
    }
}

final class MovieReviewsViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
        
    func display(_ viewModel: MovieReviewsViewModel) {
        controller?.display(viewModel.reviews.map { viewModel in
            CellController(id: viewModel, MovieReviewCellController(model: viewModel))
        })
    }
}
