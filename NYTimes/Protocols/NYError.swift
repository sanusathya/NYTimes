//
//  NYError.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

protocol ErrorProtocol: LocalizedError {
    
    var title: String? { get }
    var code: Int { get }
}

struct NYError: ErrorProtocol {
    
    var title: String?
    var code: Int
    var errorDescription: String? { return description }
    var failureReason: String? { return description }
    
    private var description: String
    
    init(title: String? = nil, description: String, code: Int) {
        self.title = title ?? "Error"
        self.description = description
        self.code = code
    }
}
