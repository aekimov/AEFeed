//
//  RemoteLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/8/23.
//

import Foundation

public final class RemoteLoader: FeedLoader {
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
                completion(RemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
