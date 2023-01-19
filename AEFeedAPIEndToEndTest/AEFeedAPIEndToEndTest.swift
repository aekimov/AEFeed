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
        case let .success(items)?:
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
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://raw.githubusercontent.com/aekimov/TestServerJSON/main/server.json")!
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
        
        return receivedResult
    }
    
    private func expectedItem(at index: Int) -> FeedImage {
        return FeedImage(
            id: id(at: index),
            title: title(at: index),
            imagePath: imagePath(at: index),
            overview: overview(at: index))
    }
    
    private func id(at index: Int) -> Int {
        return [283552, 342521, 363676, 363841, 338189][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "The Light Between Oceans",
            "Keanu",
            "Sully",
            "Guernika",
            "It's Only the End of the World"
        ][index]
    }
    
    private func imagePath(at index: Int) -> String {
        return [
            "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg",
            "/udU6t5xPNDLlRTxhjXqgWFFYlvO.jpg",
            "/1BdD1kMK1phbANQHmddADzoeKgr.jpg",
            "/2gd30NS4RD6XOnDlxp7nXYiCtT1.jpg",
            "/ag6NsqD8tpDGgAcs4CnfdI3miSD.jpg"
        ][index]
    }
    
    private func overview(at index: Int) -> String {
        return [
            "A lighthouse keeper and his wife living off the coast of Western Australia raise a baby they rescue from an adrift rowboat.",
            "Friends hatch a plot to retrieve a stolen cat by posing as drug dealers for a street gang.",
            "On January 15, 2009, the world witnessed the \"Miracle on the Hudson\" when Captain \"Sully\" Sullenberger glided his disabled plane onto the frigid waters of the Hudson River, saving the lives of all 155 aboard. However, even as Sully was being heralded by the public and the media for his unprecedented feat of aviation skill, an investigation was unfolding that threatened to destroy his reputation and his career.",
            "The fates of Henry - an American correspondent - and Teresa, one of the Republic's censors during the Spanish Civil War.",
            "Louis, a terminally ill writer, returns home after a long absence to tell his family that he is dying."
        ][index]
    }
}
