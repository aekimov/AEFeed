//
//  FeedItemsMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let results: [RemoteItem]
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.results
    }
}

