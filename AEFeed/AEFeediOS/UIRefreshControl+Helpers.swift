//
//  UIRefreshControl+Helpers.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/24/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
