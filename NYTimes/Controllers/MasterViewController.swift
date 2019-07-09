//
//  MasterViewController.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    private var articles: [Article]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All Sections"
        loadMostViewedArticles(section: "all-sections", timePeriod: "7")
    }
    
    func loadMostViewedArticles(section: String, timePeriod: String) {
        MostViewedAPI.fetchMostViewedArticles(section: section, timePeriod: timePeriod, offset:offset).done { [weak self] (sectionsResponse) in
            guard let welf = self else { return }
            welf.articles = sectionsResponse?.articles
            }.catch { error in
                print("Error \(error.localizedDescription)")
        }
    }
}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ArticleTableViewCell.dequeueReusableCell(in: tableView, indexPath: indexPath)
        cell.article = articles?[indexPath.row]
        return cell
    }
}
