//
//  UIImageViewExtensions.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImage(with url: URL?) {
        guard let url = url else { return }
        af_setImage(withURL: url)
    }
}
