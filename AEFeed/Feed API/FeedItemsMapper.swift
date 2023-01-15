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

    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.results
    }
}

