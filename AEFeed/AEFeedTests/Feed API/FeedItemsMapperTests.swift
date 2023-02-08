//
//  FeedItemsMapperTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 10/30/22.
//

import XCTest
import AEFeed

class FeedItemsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        let json = makeItemsJSON([])
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_throwsNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try FeedItemsMapper.map(emptyListJSON, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }

    func test_map_throwsItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID().hashValue, title: "item1", imagePath: "path1", overview: "overview1")
        let item2 = makeItem(id: UUID().hashValue, title: "item2", imagePath: "path2", overview: "overview2")
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: 200))

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
    
    private func makeItem(id: Int, title: String, imagePath: String? = nil, overview: String) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, title: title, imagePath: imagePath ?? "", overview: overview)
        
        let json: [String: Any] = [
            "id": item.id,
            "title": item.title,
            "poster_path": item.imagePath,
            "overview": item.overview
        ]
        
        return (item, json)
    }
}
