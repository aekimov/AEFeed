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
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    //MARK:- Helpers
    
    private func makeSUT() -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
}
