//
//  DequeueReusable.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

protocol DequeueReusable {
    static func dequeueReusableCell(in view: UIView, indexPath: IndexPath) -> Self
}

extension UITableViewCell: DequeueReusable {}

extension DequeueReusable where Self: UITableViewCell {
    static func dequeueReusableCell(in view: UIView, indexPath: IndexPath) -> Self {
        guard let tableView = view as? UITableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as? Self else { return Self() }
        return cell
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
}
