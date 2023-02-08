//
//  MovieReviewsMapperTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 2/7/23.
//

import XCTest
import AEFeed

class MovieReviewsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        let json = makeItemsJSON([])
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try MovieReviewsMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try MovieReviewsMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_throwsNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try MovieReviewsMapper.map(emptyListJSON, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }

    func test_map_throwsItemsOn200HTTPResponseWithJSONItems() throws {        
        let item1 = makeItem(
            id: "\(UUID().hashValue)",
            author: "an author",
            content: "any content",
            createdAt: (date: Date(timeIntervalSince1970: 1675740020), iso8601String: "2023-02-07T03:20:20.000Z")
        )
        
        let item2 = makeItem(
            id: "\(UUID().hashValue)",
            author: "another author",
            content: "any other content",
            createdAt: (date: Date(timeIntervalSince1970: 1675683997), iso8601String: "2023-02-06T11:46:37.000Z")
        )
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try MovieReviewsMapper.map(json, HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    
    //MARK:- Helpers
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    
    private func makeFeed(items: [(model: FeedImage, json: [String : Any])] = []) -> (model: [FeedImage], json: [String: Any]) {
        let model = items.map { $0.model }

        let json: [String: Any] = [
            "results": items.map { $0.json }
        ]

        return (model, json.compactMapValues { $0 })
    }
    
    private func makeItem(id: String, author: String, content: String, createdAt: (date: Date, iso8601String: String)) -> (model: MovieReview, json: [String: Any]) {
        let item = MovieReview(id: id, author: author, content: content, createdAt: createdAt.date)
        
        let json: [String: Any] = [
            "id": id,
            "author": author,
            "content": content,
            "created_at": createdAt.iso8601String
        ]
        
        return (item, json)
    }
}

