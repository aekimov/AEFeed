//
//  UIButton+TestHelpers.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/2/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
