//
//  Book.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct Book: Codable, Hashable {
    
    var id: Identifier<Book>
    var title: String
    var createdAt: Date
    
    init(id: Identifier<Book> = Identifier(UUID().uuidString), title: String) {
        self.id = id
        self.title = title
        self.createdAt = Date()
    }
    
}
