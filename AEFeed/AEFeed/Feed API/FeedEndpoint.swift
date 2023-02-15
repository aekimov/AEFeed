//
//  FeedEndpoint.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/13/23.
//

import Foundation

public enum FeedEndpoint {
    case get(page: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(page):
            return configure(baseURL, page: page)
        }
    }
    
    private func configure(_ url: URL, page: Int) -> URL {
        let requestURL = url.appendingPathComponent("3").appendingPathComponent("movie").appendingPathComponent("upcoming")
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return urlComponents?.url ?? requestURL
    }
}
