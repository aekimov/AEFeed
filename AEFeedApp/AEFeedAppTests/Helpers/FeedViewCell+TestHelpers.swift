//
//  FeedViewCell+TestHelpers.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/2/23.
//

import AEFeediOS
import Foundation

extension FeedImageCell {
    var titleText: String? {
        return titleLabel.text
    }

    var overviewText: String? {
        return overviewLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return feedImageView.isShimmering
    }
    
    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
    
    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }
    
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
    
}
