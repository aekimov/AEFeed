//
//  TableViewController.swift
//  AEFeedPrototype
//
//  Created by Artem Ekimov on 1/19/23.
//

import UIKit

class TableViewController: UITableViewController {
    private let items: [FeedImage]
    
    init(items: [FeedImage]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Movies"
        tableView.register(FeedCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedCell = tableView.dequeueReusableCell()
        cell.configure(items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

struct FeedImage: Equatable {
    let id: Int
    let title: String
    let imagePath: String
    let overview: String
    
    init(id: Int, title: String, imagePath: String, overview: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.overview = overview
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(_ name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
