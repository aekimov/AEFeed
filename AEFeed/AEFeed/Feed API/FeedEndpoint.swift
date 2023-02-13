//
//  FeedEndpoint.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/13/23.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return configure(baseURL)
        }
    }
    
    private func configure(_ url: URL) -> URL {
        let requestURL = url.appendingPathComponent("3").appendingPathComponent("movie").appendingPathComponent("upcoming")
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        return urlComponents?.url ?? requestURL
    }
}
