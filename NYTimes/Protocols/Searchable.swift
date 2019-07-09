//
//  Searchable.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Foundation

protocol Searchable {
    func passesSearch(for key: String) -> Bool
}
