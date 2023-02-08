//
//  LoadFeedFromRemoteUseCaseTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 10/30/22.
//

import XCTest
import AEFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let(sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let(sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let(sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let(sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID().hashValue, title: "item1", imagePath: "path1", overview: "overview1")
        let item2 = makeItem(id: UUID().hashValue, title: "item2", imagePath: "path2", overview: "overview2")
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    //MARK:- Helpers
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
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
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
    }
}
