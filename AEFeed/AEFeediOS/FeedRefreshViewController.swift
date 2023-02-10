//
//  FeedRefreshViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import UIKit
import AEFeed

public final class FeedRefreshViewController: NSObject, ResourceLoadingView {
    private(set) lazy var view = loadView()
    
    private let onRefresh: () -> Void
    
    public init(onRefresh: @escaping () -> Void) {
        self.onRefresh = onRefresh
    }
    
    @objc func refresh() {
        onRefresh()
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        view.update(isRefreshing: viewModel.isLoading)
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }

}
