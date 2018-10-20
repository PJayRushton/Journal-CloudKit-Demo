//
//  AppState.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

enum App {
    static let sharedCore = Core(state: AppState())
}


struct AppState: State {
    
    var books = Set<Book>()
    var selectedBook: Book?
    var selectedPage: Page?
    var newPage: Page?
    var pages = Set<Page>()
    
    var currentPage: Page? {
        return newPage ?? selectedPage
    }
    
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ObjectAdded<Book>:
            books.insert(event.object)
        case let event as ObjectAdded<[Book]>:
            books.formUnion(event.object)
        case let event as ObjectAdded<Page>:
            pages.update(with: event.object)
        case let event as ObjectAdded<[Page]>:
            pages.formUnion(event.object)
        case let event as ObjectUpdated<Page>:
            if newPage == event.object {
                newPage = event.object
            } else {
                pages.update(with: event.object)
            }
        case let event as Selected<Book>:
            selectedBook = event.object
        case let event as Selected<Page>:
            selectedPage = event.object
        case let event as CreationStarted<Page>:
            newPage = event.object
        case let event as CreationFinished<Page>:
            pages.update(with: event.object)
            newPage = nil
        case _ as CreationCancelled<Page>:
            newPage = nil
        default:
            break
        }
    }
    
    func pages(for book: Book) -> Set<Page> {
        return pages.filter { $0.bookId == book.identifier }
    }
    
}
