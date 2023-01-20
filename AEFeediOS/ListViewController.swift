//
//  ListViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import UIKit
import AEFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from path: String, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}

public class ListViewController: UITableViewController {
    private let feedLoader: FeedLoader
    private let imageLoader: FeedImageDataLoader
    
    public init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items: [FeedImage] = []
    private var tasks: [IndexPath: FeedImageDataLoaderTask] = [:]

    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.items = feed
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = FeedImageCell()
        cell.titleLabel.text = item.title
        cell.overviewLabel.text = item.overview
        cell.feedImageView.startShimmering()
        tasks[indexPath] = imageLoader.loadImageData(from: item.imagePath) { [weak self] result in
            cell.feedImageView.stopShimmering()
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
    }
}
