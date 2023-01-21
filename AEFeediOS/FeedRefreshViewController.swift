//
//  FeedRefreshViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import AEFeed
import UIKit

public final class FeedRefreshViewController: NSObject {
    private(set) lazy var view = bind(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    public var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func bind(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
            
            if let feed = viewModel.feed {
                self?.onRefresh?(feed)
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }

}
