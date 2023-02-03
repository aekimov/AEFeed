//
//  ErrorView.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/24/23.
//

import UIKit

public final class ErrorView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(hideMessageAnimated)))
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomConstaint = bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
    
    private func setup() {
        label.text = nil
        alpha = 0
        backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 1)
        bottomConstaint.priority = .defaultLow - 1
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            bottomConstaint
        ])
    }
    
    public var message: String? {
        get {
            return isVisible ? label.text : nil
        }
        set {
            setMessageAnimated(newValue)
        }
    }
    
    private var isVisible: Bool {
        return alpha > 0
    }
    
    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }
    
    private func showAnimated(_ message: String) {
        label.text = message
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }, completion: { completed in
            if completed { self.label.text = nil }
        })
    }
}
