//
//  UITableView+Extension.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/22/23.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
