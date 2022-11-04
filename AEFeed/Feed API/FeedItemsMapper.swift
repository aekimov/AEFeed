//
//  FeedItemsMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public final class FeedItemsMapper {

    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> RemoteFeed {
        guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteFeed.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return page
    }
}

