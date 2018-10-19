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

    fileprivate var isNew = false
    fileprivate var page: Page?
    fileprivate let core = App.sharedCore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = core.state.currentPage?.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        core.fire(command: SavePage())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

}


// MARK: - Subscriber

extension PageDetailViewController: Subscriber {
    
    func update(with state: AppState) {
        page = state.currentPage
        isNew = state.newPage != nil
    }
    
}


extension PageDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        core.fire(command: UpdatePageText(text: textView.text))
    }
    
}
