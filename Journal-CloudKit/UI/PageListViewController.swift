//
//  PageListViewController.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import UIKit

class PageListViewController: UITableViewController {
    
    fileprivate let core = App.sharedCore
    fileprivate var pages = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
    
}


extension PageListViewController: Subscriber {
    
    func update(with state: AppState) {
        guard let selectedBook = state.selectedBook else { return }
        pages = state.pages(for: selectedBook).sorted(by: { $0.modifiedAt > $1.modifiedAt })
        tableView.reloadData()
    }
    
}


// MARK: - Private

private extension PageListViewController {
    
    func page(at indexPath: IndexPath) -> Page {
        return pages[indexPath.row]
    }
    
}


// MARK: - Navigation

extension PageListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "createNewPage":
            core.fire(command: CreateNewPage())
        case "showPageDetail":
           break
        default:
            return
        }
    }
    
}


// MARK: - TableView
// MARK: - Delegate

extension PageListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPage = page(at: indexPath)
        core.fire(event: Selected<Page>(selectedPage))
        performSegue(withIdentifier: "showPageDetail", sender: nil)
    }
    
}


// MARK: - TableView Datasourse

extension PageListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageListCell", for: indexPath)
        let page = self.page(at: indexPath)
        cell.textLabel?.text = page.title
        return cell
    }
    
}
