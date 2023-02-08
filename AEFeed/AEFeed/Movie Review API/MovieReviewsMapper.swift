//
//  MovieReviewsMapper.swift
//  AEFeed
//
//  Created by Artem Ekimov on 2/7/23.
//

import Foundation

public final class MovieReviewsMapper {
    
    private struct Root: Decodable {
        private let results: [Item]
        
        private struct Item: Decodable {
            let id: String
            let author: String
            let content: String
            let created_at: Date
        }
        
        var reviews: [MovieReview] {
            results.map { MovieReview(id: $0.id, author: $0.author, content: $0.content, createdAt: $0.created_at)}
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [MovieReview] {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw Error.invalidData
        })
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.reviews
    }
}


