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
    var pages = [Identifier<Book>: Set<Page>]()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as ObjectAdded<Book>:
            books.insert(event.object)
        default:
            break
        }
    }
    
}
