//
//  ListViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import AEFeed
import UIKit

public class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private let refreshController: FeedRefreshViewController
    private let imageLoader: FeedImageDataLoader
    
    public init(refreshController: FeedRefreshViewController, imageLoader: FeedImageDataLoader) {
        self.refreshController = refreshController
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var models: [FeedImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var cellControllers: [IndexPath: FeedImageCellController] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshController.view
        refreshController.onRefresh = { [weak self] feed in
            self?.models = feed
        }
        refreshController.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let model = models[indexPath.row]
        let cellController = FeedImageCellController(model: model, imageLoader: imageLoader)
        cellControllers[indexPath] = cellController
        return cellController
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
