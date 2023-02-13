//
//  LoadMoreCellController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 2/13/23.
//

import UIKit
import AEFeed

public final class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let loadMoreCell = LoadMoreCell()
    private let callback: () -> Void
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return loadMoreCell
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }

    private func reloadIfNeeded() {
        guard !loadMoreCell.isLoading else { return }
        callback()
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        loadMoreCell.message = viewModel.message
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        loadMoreCell.isLoading = viewModel.isLoading
    }
}
