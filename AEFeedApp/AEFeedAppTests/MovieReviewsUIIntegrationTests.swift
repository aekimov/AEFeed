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
    
    func test_loadingReviewsIndicator_isVisibleWhileLoadingReviews() {
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
    
    func test_loadReviewsCompletion_rendersSuccessfullyLoadedReviews() {
        let review0 = makeReview(author: "author1", content: "content1", createdAt: Date())
        let review1 = makeReview(author: "author2", content: "content2", createdAt: Date())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [MovieReview]())

        loader.completeReviewsLoading(with: [review0], at: 0)
        assertThat(sut, isRendering: [review0])

        sut.simulateUserInitiatedReload()
        loader.completeReviewsLoading(with: [review0, review1], at: 1)
        assertThat(sut, isRendering: [review0, review1])
    }
    
    func test_loadReviewsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeReview()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeReviewsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedReload()
        loader.completeReviewsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    func test_loadReviewsCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyReviews() {
         let image = makeReview()
         let (sut, loader) = makeSUT()

         sut.loadViewIfNeeded()
         loader.completeReviewsLoading(with: [image], at: 0)
         assertThat(sut, isRendering: [image])

         sut.simulateUserInitiatedReload()
         loader.completeReviewsLoading(with: [], at: 1)
         assertThat(sut, isRendering: [MovieReview]())
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

    
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = MovieReviewsUIComposer.reviewsComposedWith(reviewsLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering reviews: [MovieReview], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedReviews(), reviews.count, "reviews count", file: file, line: line)
        
        let viewModel = MovieReviewsPresenter.map(reviews)
        
        viewModel.reviews.enumerated().forEach { index, review in
            XCTAssertEqual(sut.reviewAuthor(at: index), review.author, "author at \(index)", file: file, line: line)
            XCTAssertEqual(sut.reviewContent(at: index), review.content, "content at \(index)", file: file, line: line)
            XCTAssertEqual(sut.reviewDate(at: index), review.date, "date at \(index)", file: file, line: line)
        }
    }

    private func makeReview(author: String = "author", content: String = "content", createdAt: Date = Date()) -> MovieReview {
        return MovieReview(id: "\(UUID().hashValue)", author: author, content: content, createdAt: createdAt)
    }
    
    private class LoaderSpy {
        private var completions: [PassthroughSubject<[MovieReview], Error>] = []
        
        var loadReviewsCallCount: Int {
            return completions.count
        }

        func loadPublisher() -> AnyPublisher<[MovieReview], Error> {
            let publisher = PassthroughSubject<[MovieReview], Error>()
            completions.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeReviewsLoading(with reviews: [MovieReview] = [], at index: Int = 0) {
            completions[index].send(reviews)
        }
        
        func completeReviewsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index].send(completion: .failure(error))
        }
    }
}
