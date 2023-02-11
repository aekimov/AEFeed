//
//  MovieReviewCellController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 2/10/23.
//

import UIKit
import AEFeed

public class MovieReviewCellController: CellController {
    private let model: MovieReviewViewModel
    
    public init(model: MovieReviewViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        tableView.register(MovieReviewCell.self)
        let cell: MovieReviewCell = tableView.dequeueReusableCell()
        cell.authorLabel.text = model.author
        cell.contentLabel.text = model.content
        cell.dateLabel.text = model.date
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
    
}
