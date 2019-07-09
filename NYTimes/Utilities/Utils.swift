//
//  Utils.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

typealias VoidClosure = () -> Void

// find top most view controller
func topController() -> UIViewController? {
    
    // recursive follow
    func follow(_ from: UIViewController?) -> UIViewController? {
        if let to = (from as? UITabBarController)?.selectedViewController {
            return follow(to)
        } else if let to = (from as? UINavigationController)?.visibleViewController {
            return follow(to)
        } else if let to = from?.presentedViewController {
            return follow(to)
        } else {
            return from
        }
    }
    
    // use our own root since when we there is a
    // UIAlertController displaying, it's the
    // keywindow root
    let root = UIApplication.shared.keyWindow?.rootViewController
    return follow(root)
}
