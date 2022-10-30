//
//  RemoteFeedLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias Result = FeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
