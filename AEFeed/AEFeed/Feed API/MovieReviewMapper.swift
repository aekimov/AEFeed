//
//  MovieReviewMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/7/23.
//

import Foundation

final class MovieReviewMapper {
    
    private struct Root: Decodable {
        let results: [RemoteItem]
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteMovieReviewsLoader.Error.invalidData
        }
        return root.results
    }
}


