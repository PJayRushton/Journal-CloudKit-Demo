//
//  RecordCreating.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/19/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation
import CloudKit

protocol RecordCreating {
    init(record: CKRecord) throws
    static var recordType: String { get }
    var cloudKitRecordID: CKRecord.ID { get }
    var cloudKitRecordProperties: [String: CKRecordValue?] { get }
    var recordWithChanges: CKRecord { get }
}

extension RecordCreating {
    
    var recordWithChanges: CKRecord {
        return CKRecord(object: self)
    }
    
}

extension Identifiable {
    
    var cloudKitRecordID: CKRecord.ID {
        return CKRecord.ID(recordName: identifier.rawValue)
    }

}


extension CKRecord {
    
    convenience init(object: RecordCreating) {
        self.init(recordType: type(of: object).recordType, recordID: object.cloudKitRecordID)
        for (key, value) in object.cloudKitRecordProperties {
            self[key] = value
        }

    }
    
}
