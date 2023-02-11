//
//  ErrorView.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/24/23.
//

import UIKit

public final class ErrorView: UIButton {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
        backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 1)
        hideMessage()
        titleLabel?.textColor = .white
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
    }

    private func hideMessage() {
        setTitle(nil, for: .normal)
        alpha = 0
        contentEdgeInsets = .init(top: -2.5, left: 0, bottom: -2.5, right: 0)
        onHide?()
    }
    
    public var message: String? {
        get {
            return isVisible ? title(for: .normal) : nil
        }
        set {
            setMessageAnimated(newValue)
        }
    }
    
    public var onHide: (() -> Void)?

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
        setTitle(message, for: .normal)
        contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }, completion: { completed in
            if completed { self.hideMessage() }
        })
    }
}
