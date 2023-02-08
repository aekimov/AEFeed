//
//  RemoteMoviewReviewsLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/7/23.
//

import Foundation

public typealias RemoteMovieReviewsLoader = RemoteLoader<[MovieReview]>

public extension RemoteMovieReviewsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: MovieReviewMapper.map)
    }
}
