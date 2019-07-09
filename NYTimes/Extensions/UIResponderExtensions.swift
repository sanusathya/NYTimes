//
//  UIResponderExtensions.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension UIResponder: Identifiable {
    static var identifier: String {
        return "\(self)"
    }
}
