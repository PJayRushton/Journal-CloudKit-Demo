//
//  Book.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation
import CloudKit

struct Book: Identifiable {
    
    var identifier: Identifier<Book>
    var title: String
    var createdAt: Date
    
    init(id: Identifier<Book> = Identifier(UUID().uuidString), title: String) {
        self.identifier = id
        self.title = title
        self.createdAt = Date()
    }
    
}

extension Book: RecordCreating {
    
    static var recordType: String {
        return "Book"
    }
    
    var cloudKitRecordProperties: [String : CKRecordValue?] {
        var properties = [String: CKRecordValue?]()
        properties["title"] = title as CKRecordValue?
        return properties
    }
    
    init(record: CKRecord) throws {
        identifier = Identifier(rawValue: record.recordID.recordName)
        title = record.value(forKey: "title") as? String ?? ""
        createdAt = record.value(forKey: "createdAt") as? Date ?? Date()
    }
    
}
