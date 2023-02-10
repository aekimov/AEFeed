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
    
    public static func map(_ reviews: [MovieReview]) -> MovieReviewsViewModel {
        let formatter = RelativeDateTimeFormatter()
        
        return MovieReviewsViewModel(reviews: reviews.map {
            MovieReviewViewModel(author: $0.author, content: $0.content, date: formatter.localizedString(for: $0.createdAt, relativeTo: Date()))
        })
    }

}

public struct MovieReviewsViewModel {
    public let reviews: [MovieReviewViewModel]
}

public struct MovieReviewViewModel: Equatable {
    public let author: String
    public let content: String
    public let date: String
    
    public init(author: String, content: String, date: String) {
        self.author = author
        self.content = content
        self.date = date
    }
}

