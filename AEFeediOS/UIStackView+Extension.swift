//
//  UIStackView+Extension.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import UIKit

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis = .vertical,
                     distribution: UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     margins: NSDirectionalEdgeInsets = .zero,
                     subviews: [UIView] = []) {
        
        self.init(arrangedSubviews: subviews)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.directionalLayoutMargins = margins
    }
}

