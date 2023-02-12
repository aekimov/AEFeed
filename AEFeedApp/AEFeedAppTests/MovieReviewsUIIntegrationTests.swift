//
//  MovieReviewsUIIntegrationTests.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 2/12/23.
//

import XCTest
import UIKit
import AEFeed
import AEFeedApp
import AEFeediOS
import Combine

final class MovieReviewsUIIntegrationTests: ListUIIntegrationTests {
    func test_movieReviewsView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, reviewsTitle)
    }
    
    func test_loadReviewsActions_requestReviewsFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadReviewsCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadReviewsCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadReviewsCallCount, 2, "Expected another loading request once user initiates a reload")
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingReviews() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected a loading indicator once view is loaded")

        loader.completeReviewsLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected a loading indicator once loading is user initiated")
        
        loader.completeReviewsLoading(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once user initiated loading is completed")
        
        loader.completeReviewsLoadingWithError(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once user initiated loading is completed with error")
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(title: "movie1", imagePath: "path1", overview: "overview1")
        let image1 = makeImage(title: "movie2", imagePath: "path2", overview: "overview2")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeReviewsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])

        sut.simulateUserInitiatedReload()
        loader.completeReviewsLoading(with: [image0, image1], at: 1)
        assertThat(sut, isRendering: [image0, image1])
    }
    
    override func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeReviewsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedReload()
        loader.completeReviewsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    override func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeReviewsLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    
    override func test_errorView_doesNotRenderErrorOnLoad() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_loadFeedCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeReviewsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
    }
    
    override func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeReviewsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeReviewsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
         let image0 = makeImage()
         let image1 = makeImage()
         let (sut, loader) = makeSUT()

         sut.loadViewIfNeeded()
         loader.completeReviewsLoading(with: [image0, image1], at: 0)
         assertThat(sut, isRendering: [image0, image1])

         sut.simulateUserInitiatedReload()
         loader.completeReviewsLoading(with: [], at: 1)
         assertThat(sut, isRendering: [])
     }
    
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = MovieReviewsUIComposer.reviewsComposedWith(reviewsLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeImage(title: String = "title", imagePath: String = "path1", overview: String = "overview") -> FeedImage {
        return FeedImage(id: UUID().hashValue, title: title, imagePath: imagePath, overview:overview)
    }
    
    private class LoaderSpy {
        private var completions: [PassthroughSubject<[FeedImage], Error>] = []
        
        var loadReviewsCallCount: Int {
            return completions.count
        }

        func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
            let publisher = PassthroughSubject<[FeedImage], Error>()
            completions.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeReviewsLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            completions[index].send(feed)
        }
        
        func completeReviewsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index].send(completion: .failure(error))
        }
    }
}
