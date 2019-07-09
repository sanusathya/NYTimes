//
//  SectionsTableViewCell.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {
    
    var section: ArticleTypeViewController.Section = .all {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel?

    private func configureView() {
        labelTitle?.text = section.name
    }
}
