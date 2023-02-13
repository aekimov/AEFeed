//
//  ListViewController+TestHelpers.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/2/23.
//

import AEFeediOS
import Foundation
import UIKit

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func simulateLoadMoreFeedAction() {
        guard let cell = loadMoreFeedCell() else { return }
        
        let delegate = tableView.delegate
        let indexPath = IndexPath(row: 0, section: loadMoreSection)
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func simulateTapOnLoadMoreFeedError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: loadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var isShowingLoadMoreFeedIndicator: Bool {
        return loadMoreFeedCell()?.isLoading == true
    }

    private func loadMoreFeedCell() -> LoadMoreCell? {
        cell(row: 0, section: loadMoreSection) as? LoadMoreCell
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return numberOfRows(in: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        return cell(row: row, section: feedImagesSection)
    }
    
    private var feedImagesSection: Int { 0 }
    private var loadMoreSection: Int { 1 }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    var loadMoreFeedErrorMessage: String? {
        return loadMoreFeedCell()?.message
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
}

extension ListViewController {

    func numberOfRenderedReviews() -> Int {
        numberOfRows(in: movieReviewsSection)
    }
    
    private var movieReviewsSection: Int { 0 }
    
    func reviewAuthor(at index: Int) -> String? {
        return reviewView(at: index)?.authorLabel.text
    }
    
    func reviewContent(at index: Int) -> String? {
        return reviewView(at: index)?.contentLabel.text
    }
    
    func reviewDate(at index: Int) -> String? {
        return reviewView(at: index)?.dateLabel.text
    }
    
    private func reviewView(at row: Int) -> MovieReviewCell? {
        return cell(row: row, section: movieReviewsSection) as? MovieReviewCell
    }
    
}
