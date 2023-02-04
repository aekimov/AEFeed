//
//  FeedImageCellController.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import UIKit
import AEFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        tableView.register(FeedImageCell.self)
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    public func display(_ model: FeedImageViewModel<UIImage>) {
        cell?.titleLabel.text = model.title
        cell?.overviewLabel.text = model.overview
        cell?.feedImageView.image = model.image
        cell?.feedImageView.setImageAnimated(model.image)
        cell?.imageViewContainer.isShimmering = model.isLoading
        cell?.feedImageRetryButton.isHidden = !model.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
