//
//  ListViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import UIKit
import AEFeed

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
    
    private var items: [FeedImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tasks: [IndexPath: FeedImageDataLoaderTask] = [:]

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshController.view
        refreshController.onRefresh = { [weak self] feed in
            self?.items = feed
        }
        refreshController.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = FeedImageCell()
        cell.titleLabel.text = item.title
        cell.overviewLabel.text = item.overview
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageView.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.tasks[indexPath] = self.imageLoader.loadImageData(from: item.imagePath) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)
                cell?.feedImageView.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let item = items[indexPath.row]
            tasks[indexPath] = imageLoader.loadImageData(from: item.imagePath) { _ in }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelTask)
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
