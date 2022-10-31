//
//  AEFeedAPIEndToEndTest.swift
//  AEFeedAPIEndToEndTest
//
//  Created by Artem Ekimov on 10/31/22.
//

import XCTest
import AEFeed

class AEFeedAPIEndToEndTest: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchedFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(feed)?:
            let items = feed.items
            XCTAssertEqual(items.count, 5, "Expected 5 items")
            XCTAssertEqual(items[0], expectedItem(at: 0))
            XCTAssertEqual(items[1], expectedItem(at: 1))
            XCTAssertEqual(items[2], expectedItem(at: 2))
            XCTAssertEqual(items[3], expectedItem(at: 3))
            XCTAssertEqual(items[4], expectedItem(at: 4))

        case let .failure(error)?:
            XCTFail("Expected succesful feed result, got \(error) instead")
        default:
            XCTFail("Expected succesful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult() -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://raw.githubusercontent.com/aekimov/TestServerJSON/main/server.json")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
        
        return receivedResult
    }
    
    private func expectedItem(at index: Int) -> FeedItem {
        return FeedItem(
            id: id(at: index),
            title: title(at: index),
            imagePath: imagePath(at: index))
    }
    
    private func id(at index: Int) -> Int {
        return [663712, 985939, 848058, 619730, 913290][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "Terrifier 2",
            "Fall",
            "Cerdita",
            "Don't Worry Darling",
            "Barbarian"
        ][index]
    }
    
    private func imagePath(at index: Int) -> String {
        return [
            "/yw8NQyvbeNXoZO6v4SEXrgQ27Ll.jpg",
            "/spCAxD99U1A6jsiePFoqdEcY0dG.jpg",
            "/8EIQAvJjXdbNDMmBtHtgGqbc09V.jpg",
            "/9BXYLjXtSipBp2GfAlsri4i8hPC.jpg",
            "/idT5mnqPcJgSkvpDX7pJffBzdVH.jpg"
        ][index]
    }
}
