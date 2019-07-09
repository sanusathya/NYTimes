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
    
    private var fullArticles: [Article]? {
        didSet {
            articles = fullArticles
        }
    }
    
    private var timePeriod = TimePeriod.week {
        didSet {
            loadMostViewedArticles()
        }
    }
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
        
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(buttonActionMenu))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButtonFilter = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action: #selector(buttonActionFilter))
        let rightBarButtonSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(buttonActionSearch))
        navigationItem.rightBarButtonItems = [rightBarButtonFilter, rightBarButtonSearch]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchBarVisible ? searchController.searchBar : nil
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .lightGray
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func loadMostViewedArticles() {
        
        LoadingIndicator.shared.show()
        MostViewedAPI.fetchMostViewedArticles(section: section.param, timePeriod: timePeriod.param, offset:offset).done { [weak self] (sectionsResponse) in
            guard let welf = self else { return }
            welf.fullArticles = sectionsResponse?.articles
            welf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }.catch { [weak self] error in
                self?.showMessage(message: error.localizedDescription)
            }.finally {
                LoadingIndicator.shared.dismiss()
        }
    }
    
    @objc func buttonActionMenu() {
        
        guard let articleTypeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ArticleTypeViewController.identifier) as? ArticleTypeViewController else { return }
        articleTypeViewController.selectionClosure = { [weak self] (section) in
            guard let welf = self else { return }
            welf.title = section.name
            welf.section = section
        }
        let presentNavigationController = UINavigationController(rootViewController: articleTypeViewController)
        navigationController?.present(presentNavigationController, animated: true, completion: nil)
    }
    
    @objc func buttonActionFilter() {
        
        let alertController = UIAlertController(title: "Please select a filter", message: "", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alertController.addAction(alertAction)
        for period in TimePeriod.allCases {
            let periodAlertAction = UIAlertAction(title: period.name, style: .default) { [weak self] (action) in
                self?.timePeriod = period
            }
            alertController.addAction(periodAlertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func buttonActionSearch() {
        searchBarVisible.toggle()
        tableView.tableHeaderView = searchBarVisible ? searchController.searchBar : nil
        tableView.reloadData()
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

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            articles = fullArticles
            return
        }
        articles = fullArticles?.filter{$0.passesSearch(for: searchText)}
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
