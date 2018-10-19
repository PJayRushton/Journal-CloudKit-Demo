//
//  Commands.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct CreateNewBook: Command {
    
    var title: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let newBook = Book(title: title)
        core.fire(event: ObjectAdded<Book>(newBook))
    }
    
}


struct CreateNewPage: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let book = state.selectedBook else { return }
        let newPage = Page(bookId: book.id, text: "")
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
    
    func execute(state: AppState, core: Core<AppState>) {
        if let newPage = state.newPage {
            if newPage.text.isEmpty {
                core.fire(event: CreationCancelled<Page>())
            } else {
                core.fire(event: CreationFinished<Page>(newPage))
            }
        } else {
            // TODO: - save
        }
    }
    
}
