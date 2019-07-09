//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var article: Article? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelAuthor: UILabel?
    @IBOutlet weak var labelPublishedDate: UILabel?
    @IBOutlet weak var labelAbstract: UILabel?
    @IBOutlet weak var imageViewLargeThumbnail: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        
        guard let article = article else { return }
        labelTitle?.text = article.title
        labelAuthor?.text = article.byline
        labelPublishedDate?.text = article.publishedDate
        labelAbstract?.text = article.abstract
        imageViewLargeThumbnail?.setImage(with: article.thumbnail)
    }
    
}
