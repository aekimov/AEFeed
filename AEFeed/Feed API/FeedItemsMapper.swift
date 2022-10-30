//
//  FeedItemsMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public final class FeedItemsMapper {
    
    private struct RemoteFeed: Decodable {
        
        struct RemoteItem: Decodable {
            let id: Int
            let original_title: String
            let poster_path: String?
        }
        
        let results: [RemoteItem]
        let page: Int
        
        var images: [FeedItem] {
            results.map { FeedItem(id: $0.id, title: $0.original_title, imagePath: $0.poster_path ?? "") }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> MoviesFeed {
        guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteFeed.self, from: data) else {
            throw Error.invalidData
        }

        return MoviesFeed(items: page.images, page: page.page)
    }
}

