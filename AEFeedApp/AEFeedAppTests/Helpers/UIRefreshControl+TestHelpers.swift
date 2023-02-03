//
//  UIRefreshControl+TestHelpers.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/2/23.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
