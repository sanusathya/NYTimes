//
//  ArticleTableViewCell.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var article: Article? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var imageViewArticle: UIImageView?
    @IBOutlet weak var labelArticleTitle: UILabel?
    @IBOutlet weak var labelArticleAuthor: UILabel?
    @IBOutlet weak var labelPublishedDate: UILabel?
    
    func configureView() {
        
        guard let article = article else { return }
        
        imageViewArticle?.setImage(with: article.thumbnail)
        
        labelArticleTitle?.text = article.title ?? ""
        labelArticleAuthor?.text = article.byline ?? ""
        labelPublishedDate?.text = article.publishedDate ?? ""
    }
}
