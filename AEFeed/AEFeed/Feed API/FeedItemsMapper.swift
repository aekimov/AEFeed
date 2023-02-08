//
//  FeedItemsMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public final class FeedItemsMapper {
    
    private struct Root: Decodable {
        private let results: [RemoteItem]
        
        var items: [FeedImage] {
            return results.map { FeedImage(id: $0.id, title: $0.title, imagePath: $0.poster_path?.removeSlash ?? "", overview: $0.overview)}
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.items
    }
}

private extension String {
    var removeSlash: String {
        var string = self
        if string.first == "/" {
            string.removeFirst()
        }
        return string
    }
}
