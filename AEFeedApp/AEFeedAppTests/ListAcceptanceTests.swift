//
//  ListAcceptanceTests.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 2/3/23.
//

import XCTest
import UIKit
import AEFeed
import AEFeediOS
@testable import AEFeedApp

final class ListAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertTrue(feed.canLoadMore)
        
        feed.simulateLoadMoreFeedAction()

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertTrue(feed.canLoadMore)
        
        feed.simulateLoadMoreFeedAction()

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertFalse(feed.canLoadMore)
        
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)

        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedImageViewVisible(at: 2)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 2), makeImageData2())

    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }

    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNotNil(store.feedCache, "Expected to keep non-expired cache")
    }
    
    func test_onImageSelection_shouldDisplayReviews() {
        let reviews = showCommentsForFirstImage()
        
        XCTAssertEqual(reviews.numberOfRenderedReviews(), 1)
        XCTAssertEqual(reviews.reviewContent(at: 0), makeContent())
    }
    
    
    // MARK: - Helpers
    
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryFeedStore = .empty) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func showCommentsForFirstImage() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)
        feed.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date())
        
        return feed.navigationController?.topViewController as! ListViewController
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/3/movie/upcoming" where url.query?.contains("page=1") == true:
            return makeFeedData()
        case "/3/movie/upcoming" where url.query?.contains("page=2") == true:
            return makeSecondFeedPage()
        case "/3/movie/upcoming" where url.query?.contains("page=3") == true:
            return makeEmptyFeedPage()
        case "/t/p/w500/imagePath0":
            return makeImageData0()
        case "/t/p/w500/imagePath1":
            return makeImageData1()
        case "/t/p/w500/imagePath2":
            return makeImageData2()
        case "/3/movie/785084/reviews":
            return makeReviewsData()
        default:
            return Data()
        }
    }

    private func makeImageData0() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .yellow).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .purple).pngData()! }


    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["results": [
            ["id": 785084,
             "title": "any title",
             "poster_path": "imagePath0",
             "overview": "any overview"],
            ["id": UUID().hashValue,
             "title": "any title",
             "poster_path": "imagePath1",
             "overview": "any overview"]
        ]])
    }
    
    private func makeSecondFeedPage() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["results": [
            ["id": UUID().hashValue,
             "title": "any title",
             "poster_path": "imagePath2",
             "overview": "any overview"]
        ]])
    }
    
    private func makeEmptyFeedPage() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["results": []])
    }
    
    private func makeReviewsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["results": [
            ["id": UUID().uuidString,
             "author": "any author",
             "content": makeContent(),
             "created_at": "2017-02-13T22:23:01.268Z"]
        ]])
    }
    
    private func makeContent() -> String {
        return "any content"
    }
}
