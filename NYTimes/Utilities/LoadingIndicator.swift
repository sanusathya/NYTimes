//
//  LoadingIndicator.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import NVActivityIndicatorView

class LoadingIndicator: UIViewController, NVActivityIndicatorViewable {
    
    private var activityView: NVActivityIndicatorView?
    
    static let shared = LoadingIndicator()
    
    func show() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballClipRotateMultiple, color: .orange, backgroundColor: .clear)
    }
    
    func dismiss() {
        stopAnimating()
        activityView?.removeFromSuperview()
    }
}
