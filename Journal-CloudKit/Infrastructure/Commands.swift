//
//  Commands.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import UIKit
import CloudKit

struct FetchBooks: Command {
    
    private let cloudManager = CloudKitManager()
    
    func execute(state: AppState, core: Core<AppState>) {
        cloudManager.fetchRecords(ofType: Book.recordType) { records in
            if let records = records {
                do {
                    let books = try records.map(Book.init)
                    core.fire(event: ObjectAdded<[Book]>(books))
                } catch {
                    dump(error)
                }
            } else {
                dump("UH OH, NO BOOKS!")
            }
        }
    }
    
}


struct FetchPages: Command {
    
    let book: Book
    private let cloudManager = CloudKitManager()
    
    init(of book: Book) {
        self.book = book
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: book.identifier.rawValue), action: .none)
        let predicate = NSPredicate(format: "bookId == %@", reference)
        cloudManager.fetchRecords(ofType: Page.recordType, predicate: predicate) { records in
            if let records = records {
                do {
                    let pages = try records.map(Page.init)
                    core.fire(event: ObjectAdded<[Page]>(pages))
                } catch {
                    dump(error)
                }
            } else {
                dump("UH OH, NO BOOKS!")
            }
        }
    }
    
}


struct CreateNewBook: Command {
    
    var title: String
    
    private let cloudManager = CloudKitManager()

    func execute(state: AppState, core: Core<AppState>) {
        let newBook = Book(title: title)
        guard let recordToSave = newBook.recordToSave else { return }
        cloudManager.saveRecord(recordToSave) { error in
            guard error == nil else { return }
            core.fire(event: ObjectAdded<Book>(newBook))
        }
    }
    
}


struct CreateNewPage: Command {
    
    private let cloudManager = CloudKitManager()

    func execute(state: AppState, core: Core<AppState>) {
        guard let book = state.selectedBook else { return }
        let newPage = Page(bookId: book.identifier, text: "")
        core.fire(event: CreationStarted(newPage))
    }
    
}


struct UpdatePageText: Command {
    
    var text: String
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var updatedPage = state.currentPage else { return }
        updatedPage.text = text
        core.fire(event: ObjectUpdated(updatedPage))
    }
    
}


struct SavePage: Command {
    
    let page: Page?
    private let cloudManager = CloudKitManager()
    fileprivate var completion: ((Error?) -> Void)?
    
    init(_ page: Page?, completion: ((Error?) -> Void)? = nil) {
        self.page = page
        self.completion = completion
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var page = page, let recordToSave = page.recordToSave else { return }
        page.modifiedAt = Date()
        if !page.isSavedInCloudKit {
            if page.text.isEmpty {
                core.fire(event: CreationCancelled<Page>())
            } else {
                cloudManager.saveRecord(recordToSave) { error in
                    if let error = error {
                        dump(error)
                    } else {
                        core.fire(event: CreationFinished<Page>(page))
                    }
                    self.completion?(error)
                }
            }
        } else {
            cloudManager.saveRecord(recordToSave) { error in
                if let error = error {
                    dump(error)
                } else {
                    core.fire(event: ObjectUpdated<Page>(page))
                }
                self.completion?(error)
            }
        }
    }
    
}
