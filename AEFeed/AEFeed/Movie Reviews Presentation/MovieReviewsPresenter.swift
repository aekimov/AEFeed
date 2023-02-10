//
//  MovieReviewsPresenter.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/9/23.
//

import Foundation

public final class MovieReviewsPresenter {
    
    public static var title: String {
        return NSLocalizedString("MOVIE_REVIEWS_VIEW_TITLE", tableName: "MovieReviews", bundle: Bundle(for: MovieReviewsPresenter.self), comment: "Title for movie reviews")
    }

}
