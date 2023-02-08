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
    
    
    func test_endToEndTestServerGETFeedImageDataResult_matchesFixedTestAccountData() {
        switch getFeedImageDataResult() {
        case let .success(data)?:
            XCTAssertFalse(data.isEmpty, "Expected non-empty image data")
            
        case let .failure(error)?:
            XCTFail("Expected successful image data result, got \(error) instead")
            
        default:
            XCTFail("Expected successful image data result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://raw.githubusercontent.com/aekimov/TestServerJSON/main/server.json")!
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        
        let _ = client.get(from: testServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try FeedItemsMapper.map(data, response))
                } catch {
                    return .failure(error)
                }
            }
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
        return [597, 804095, 646389, 505642, 1024546][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "Titanic",
            "The Fabelmans",
            "Plane",
            "Black Panther: Wakanda Forever",
            "Detective Knight: Rogue"
        ][index]
    }
    
    private func imagePath(at index: Int) -> String {
        return [
            "9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
            "xId9zoiv5WPQOuxqykUDrlpmrUz.jpg",
            "2g9ZBjUfF1X53EinykJqiBieUaO.jpg",
            "sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
            "2wj5iUJ2B5AQ1lFctJgUrHHsp9B.jpg"
        ][index]
    }
    
    private func overview(at index: Int) -> String {
        return [
            "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fiancé. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic's departure through to its death—on its first and last voyage—on April 15, 1912.",
            "Growing up in post-World War II era Arizona, young Sammy Fabelman aspires to become a filmmaker as he reaches adolescence, but soon discovers a shattering family secret and explores how the power of films can help him see the truth.",
            "After a heroic job of successfully landing his storm-damaged aircraft in a war zone, a fearless pilot finds himself between the agendas of multiple militias planning to take the plane and its passengers hostage.",
            "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death. As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.",
            "As Los Angeles prepares for Halloween, mask-wearing armed robbers critically wound detective James Knight’s partner in a shootout following a heist. With Knight in hot pursuit, the bandits flee L.A. for New York, where the detective’s dark past collides with his present case and threatens to tear his world apart…unless redemption can claim Knight first."
        ][index]
    }
    
    private func getFeedImageDataResult(file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoader.Result? {
        let testServerURL = URL(string: "https://github.com/aekimov/TestServerJSON/blob/main/test-image.png")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedImageDataLoader.Result?
        _ = loader.loadImageData(from: testServerURL) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }

}
