//
//  MovieReviewsEndpoint.swift.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/13/23.
//

import Foundation

public enum MovieReviewsEndpoint {
    case get(Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(movieId):
            return configure(baseURL, movieId)
        }
    }
    
    private func configure(_ url: URL, _ movieId: Int) -> URL {
        let requestURL = url
            .appendingPathComponent("3")
            .appendingPathComponent("movie")
            .appendingPathComponent("\(movieId)")
            .appendingPathComponent("reviews")
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        return urlComponents?.url ?? requestURL
    }
}
