//
//  Page.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation
import CloudKit

struct Page: Identifiable {
    
    var identifier: Identifier<Page>
    var bookId: Identifier<Book>
    var createdAt: Date
    var modifiedAt: Date
    var text: String
    fileprivate(set) var encodedSystemFields: Data?

    var title: String? {
        return text.components(separatedBy: "\n").first
    }
    var bookReference: CKRecord.Reference {
        return CKRecord.Reference(recordID: CKRecord.ID(recordName: bookId.rawValue), action: CKRecord.Reference.Action.deleteSelf)
    }
    
    init(id: Identifier<Page> = Identifier(UUID().uuidString), bookId: Identifier<Book>, text: String = "") {
        self.identifier = id
        self.createdAt = Date()
        self.bookId = bookId
        self.text = text
        self.modifiedAt = Date()
    }
    
}

extension Page: RecordCreating {
    
    static var recordType: String {
        return "Page"
    }
    
    var cloudKitRecordProperties: [String : CKRecordValue?] {
        var properties = [String: CKRecordValue?]()
        properties["bookId"] = bookReference as CKRecord.Reference?
        properties["text"] = text as CKRecordValue?
        return properties
    }
    
    init(record: CKRecord) throws {
        identifier = Identifier(rawValue: record.recordID.recordName)
        let bookRef = record.value(forKey: "bookId") as? CKRecord.Reference
        bookId = Identifier(rawValue: bookRef?.recordID.recordName ?? "")
        createdAt = record.value(forKey: "creationDate") as? Date ?? Date()
        modifiedAt = record.value(forKey: "modificationDate") as? Date ?? Date()
        text = record.value(forKey: "text") as? String ?? ""
        encodedSystemFields = record.encodedSystemFieldsData
    }

}
