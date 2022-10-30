//
//  RemoteFeedLoaderTests.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 10/30/22.
//

import XCTest
import AEFeed

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestData() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURL() {
        let url = URL(string: "https://given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let(sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "any-error", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let(sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let feed = makeFeed()
                let data = makeItemsJSON(feed.json)
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let(sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let(sut, client) = makeSUT()
        let feed = makeFeed(items: [])
        
        expect(sut, toCompleteWith: .success(feed.model)) {
            let json = makeItemsJSON(feed.json)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let(sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID().hashValue, title: "item1", imagePath: "/path1")
        let item2 = makeItem(id: UUID().hashValue, title: "item2", imagePath: "/path2")
        let feed = makeFeed(items: [item1, item2])
        
        expect(sut, toCompleteWith: .success(feed.model)) {
            let json = makeItemsJSON(feed.json)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)

        var capturedResults = [RemoteFeedLoader.RFResult]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([:]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK:- Helpers
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func makeItemsJSON(_ items: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func makeFeed(items: [(model: FeedItem, json: [String : Any])] = [], pageNumber: Int = 1) -> (model: MoviesFeed, json: [String: Any]) {
        
        let model = MoviesFeed(items: items.map { $0.model }, page: pageNumber)
        
        let json: [String: Any] = [
            "results": items.map { $0.json },
            "page": pageNumber
        ]
        
        return (model, json.compactMapValues { $0 })
    }
    
    private func makeItem(id: Int, title: String, imagePath: String? = nil) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(id: id, title: title, imagePath: imagePath ?? "")
        
        let json: [String: Any] = [
            "id": item.id,
            "original_title": item.title,
            "poster_path": item.imagePath
        ]
        
        return (item, json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.RFResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults: [RemoteFeedLoader.RFResult] = []
        
        sut.load { capturedResults.append($0) }
        
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }

    private class HTTPClientSpy: HTTPClient {
        private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
}
