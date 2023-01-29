//
//  ErrorView.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/24/23.
//

import UIKit

public final class ErrorView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(hideMessageAnimated)))
        return label
    }()
    
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.label.text = nil }
            })
    }
}
