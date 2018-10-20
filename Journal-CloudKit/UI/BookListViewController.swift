//
//  BookListViewController.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import UIKit

class BookListViewController: UITableViewController {

    private let core = App.sharedCore
    private var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        core.fire(command: FetchBooks())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
    
    @IBAction func addBookButtonPressed() {
        presentNewBookAlert()
    }
    
}


// MARK: - Subscriber

extension BookListViewController: Subscriber {
    
    func update(with state: AppState) {
        self.books = state.books.sorted(by: { $0.createdAt < $1.createdAt })
        tableView.reloadData()
    }
    
}


// MARK: - Private

private extension BookListViewController {
    
    func setUpTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func presentNewBookAlert() {
        let alert = UIAlertController(title: "New Book", message: "Enter the name of the new book", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            self.core.fire(command: CreateNewBook(title: alert.textFields?.first?.text ?? "New Book"))
        }
        saveAction.isEnabled = false
        
        alert.addTextField { textField in
            textField.placeholder = "Book Title"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main, using: { notification in
                saveAction.isEnabled = textField.text != ""
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func book(at indexPath: IndexPath) -> Book {
        return books[indexPath.row]
    }
    
}


// MARK: - Navigation

extension BookListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
    
}


// MARK: - Table View

extension BookListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = book(at: indexPath)
        core.fire(event: Selected<Book>(selectedBook))
    }
    
}


extension BookListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath)
        let book = self.book(at: indexPath)
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = String(describing: book.createdAt)
        return cell
    }

}
