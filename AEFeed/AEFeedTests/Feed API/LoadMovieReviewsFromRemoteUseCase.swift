//
//  LoadMovieReviewsFromRemoteUseCase.swift
//  AEFeedTests
//
//  Created by Artem Ekimov on 2/7/23.
//

import XCTest
import AEFeed

class LoadMovieReviewsFromRemoteUseCase: XCTestCase {
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
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "any-error", code: 0)
            client.complete(with: clientError)
        }
    }
    
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
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: RemoteMovieReviewsLoader? = RemoteMovieReviewsLoader(url: url, client: client)

        var capturedResults = [RemoteMovieReviewsLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK:- Helpers
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteMovieReviewsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieReviewsLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteMovieReviewsLoader.Error) -> RemoteMovieReviewsLoader.Result {
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
    
    private func expect(_ sut: RemoteMovieReviewsLoader, toCompleteWith expectedResult: RemoteMovieReviewsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            
            case let (.failure(receivedError as RemoteMovieReviewsLoader.Error), .failure(expectedError as RemoteMovieReviewsLoader.Error)):
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

