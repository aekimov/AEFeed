//
//  ListUIIntegrationTests+Localization.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 1/22/23.
//

import Foundation
import XCTest
import AEFeed

extension ListUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
    
    var reviewsTitle: String {
        MovieReviewsPresenter.title
    }
}
