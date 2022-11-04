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
                completion(RemoteFeedLoader.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> FeedLoader.Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(MoviesFeed(items: items.results.toModels(), page: items.page))
        } catch {
            return .failure(error)
        }
    }
}

extension Array where Element == RemoteItem {
    func toModels() -> [FeedItem] {
        return map { FeedItem(id: $0.id, title: $0.original_title, imagePath: $0.poster_path ?? "") }
    }
}
