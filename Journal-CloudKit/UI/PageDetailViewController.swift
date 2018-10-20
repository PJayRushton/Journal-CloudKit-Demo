//
//  PageDetailViewController.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import UIKit

class PageDetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    fileprivate var isNew: Bool {
        return core.state.newPage != nil
    }
    fileprivate var updatedPage: Page?
    fileprivate let core = App.sharedCore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatedPage = core.state.currentPage
        textView.text = updatedPage?.text
    }
    
    @IBAction func save() {
        core.fire(command: SavePage(updatedPage, completion: { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showSaveErrorAlert()
            }
        }))
    }

}


extension PageDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updatedPage?.text = textView.text
    }
    
}


private extension PageDetailViewController {
    
    func showSaveErrorAlert() {
        let alert = UIAlertController(title: "Hmm...", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "🤷🏻‍♂️", style: .cancel))
        present(alert, animated: true)
    }

}
