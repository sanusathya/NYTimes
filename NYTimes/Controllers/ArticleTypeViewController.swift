//
//  ArticleTypeViewController.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import UIKit

class ArticleTypeViewController: UIViewController {
    
    var sections: Section = .all {
        didSet {
            tableView?.reloadData()
        }
    }
    
    typealias SelectionClosure = (Section) -> Void
    var selectionClosure: SelectionClosure?
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select section"
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(buttonActionCancel))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func buttonActionCancel() {
        selectionClosure = nil
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ArticleTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SectionsTableViewCell.dequeueReusableCell(in: tableView, indexPath: indexPath)
        cell.section = Section.allCases[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = Section.allCases[indexPath.row]
        selectionClosure?(section)
        selectionClosure = nil
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ArticleTypeViewController {
    
    enum Section: String, CaseIterable {
        case all
        case arts
        case books
        case briefing
        case business
        case climate
        case education
        case fashion
        case food
        case health
        case magazine
        case science
        case sports
        case style
        case technology
        case world
        case well
        case travel
        
        var name: String {
            switch self {
            case .all: return "All"
            default: return rawValue.capitalized
            }
        }
        
        var param: String {
            switch self {
            case .all: return "all-sections"
            default: return rawValue.capitalized
            }
        }
    }
}
