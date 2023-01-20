//
//  ListViewController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import UIKit
import AEFeed

public class ListViewController: UITableViewController {
    private let loader: FeedLoader
    private var items: [FeedImage] = []
    
    public init(loader: FeedLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader.load { [weak self] result in
            self?.items = (try? result.get()) ?? []
            self?.tableView.reloadData()
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
        return cell
    }
}
