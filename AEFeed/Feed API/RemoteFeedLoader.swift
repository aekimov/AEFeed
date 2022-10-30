//
//  RemoteFeedLoader.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation


public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias RFResult = Result<MoviesFeed, Error>
    
    public func load(completion: @escaping (RFResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(MoviesFeed(items: root.results.map { FeedItem(id: $0.id, title: $0.original_title, imagePath: $0.poster_path ?? "")}, page: root.page)))
                } else {
                    completion(.failure(.invalidData))
                }
                               
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

struct Root: Decodable {
    
    struct RemoteItem: Decodable {
        let id: Int
        let original_title: String
        let poster_path: String?
    }
    
    let results: [RemoteItem]
    let page: Int
}
