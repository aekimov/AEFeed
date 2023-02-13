//
//  UIView+TestHelpers.swift
//  AEFeedAppTests
//
//  Created by Artem Ekimov on 2/5/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}

