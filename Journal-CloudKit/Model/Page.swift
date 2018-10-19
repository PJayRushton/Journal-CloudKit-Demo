//
//  Page.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct Page: Identifiable {
    
    var identifier: Identifier<Page>
    var bookId: Identifier<Book>
    var createdAt: Date
    var modifiedAt: Date
    var text: String
    
    var title: String? {
        return text.components(separatedBy: "\n").first
    }
    
    init(id: Identifier<Page> = Identifier(UUID().uuidString), bookId: Identifier<Book>, text: String = "") {
        self.identifier = id
        self.createdAt = Date()
        self.bookId = bookId
        self.text = text
        self.modifiedAt = Date()
    }
    
}
