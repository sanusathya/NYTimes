//
//  MasterViewController.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    //reload data while changing the articles
    private var articles: [Article]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // the entire articles list
    private var fullArticles: [Article]? {
        didSet {
            articles = fullArticles
        }
    }
    
    // need to do service call & reload data while changing the article time peiod
    private var timePeriod = TimePeriod.week {
        didSet {
            loadMostViewedArticles()
        }
    }
    
    // need to do service call & reload data while changing the article type
    private var section = ArticleTypeViewController.Section.all {
        didSet {
            loadMostViewedArticles()
        }
    }
    
    private var offset = 0
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        loadMostViewedArticles()
    }
    
    private func configureView() {
        
        title = section.name
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchBarVisible ? searchController.searchBar : nil
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .lightGray
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func loadMostViewedArticles() {
        
        LoadingIndicator.shared.show()
        MostViewedAPI.fetchMostViewedArticles(section: section.param, timePeriod: timePeriod.param, offset: offset).done { [weak self] (sectionsResponse) in
            guard let welf = self else { return }
            welf.fullArticles = sectionsResponse?.articles
            welf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }.catch { [weak self] error in
                self?.showMessage(message: error.localizedDescription)
            }.finally {
                LoadingIndicator.shared.dismiss()
        }
    }
    
    @IBAction func buttonActionMore(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: "Please select a filter", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(alertAction)
        for period in TimePeriod.allCases {
            let periodAlertAction = UIAlertAction(title: period.name, style: .default) { [weak self] (_) in
                self?.timePeriod = period
            }
            alertController.addAction(periodAlertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonActionSearch(_ sender: Any) {
        searchBarVisible.toggle()
        tableView.tableHeaderView = searchBarVisible ? searchController.searchBar : nil
        tableView.reloadData()
    }
}

extension MasterViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
        case "menu":
            guard let menuNavigationController = segue.destination as? UINavigationController,
                  let  articleTypeViewController = menuNavigationController.viewControllers.first as? ArticleTypeViewController else { return }
            articleTypeViewController.selectionClosure = { [weak self] (section) in
                guard let welf = self else { return }
                welf.title = section.name
                welf.section = section
            }
        case "detail":
            guard let detailViewController = segue.destination as? DetailViewController else { return }
            detailViewController.article = sender as? Article
        default: break
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: articles?[indexPath.row])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            articles = fullArticles
            return
        }
        articles = fullArticles?.filter {$0.passesSearch(for: searchText)}
    }
}

extension MasterViewController {
    enum TimePeriod: String, CaseIterable {
        case day
        case week
        case month
        
        var name: String {
            return rawValue.capitalized
        }
        
        var param: String {
            switch self {
            case .day: return "1"
            case .week: return "7"
            case .month: return "30"
            }
        }
    }
}
