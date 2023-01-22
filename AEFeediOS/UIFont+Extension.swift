//
//  UIFont+Extension.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import UIKit

public extension UIFont {
    static func setFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
