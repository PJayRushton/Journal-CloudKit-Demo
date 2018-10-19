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
