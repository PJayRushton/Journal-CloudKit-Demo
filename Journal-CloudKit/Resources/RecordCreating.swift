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
    static var recordType: String { get }
    init(record: CKRecord) throws
    var cloudKitRecordID: CKRecord.ID { get }
    var cloudKitRecordProperties: [String: CKRecordValue?] { get }
    var isSavedInCloudKit: Bool { get }
    var recordWithChanges: CKRecord? { get }
    var recordToSave: CKRecord? { get }
    var encodedSystemFields: Data? { get }
}

extension RecordCreating {
    
    var isSavedInCloudKit: Bool {
        return encodedSystemFields != nil
    }
    var recordToSave: CKRecord? {
        return isSavedInCloudKit ? recordWithChanges : CKRecord(object: self)
    }
    
    var recordWithChanges: CKRecord? {
        guard let encodedSystemFields = encodedSystemFields else { return nil }
        let coder = try! NSKeyedUnarchiver(forReadingFrom: encodedSystemFields)
        coder.requiresSecureCoding = true
        let record = CKRecord(coder: coder)
        coder.finishDecoding()
        for (key, value) in cloudKitRecordProperties {
            record?[key] = value
        }
        return record
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
    
    public var encodedSystemFieldsData: Data {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        encodeSystemFields(with: coder)
        coder.finishEncoding()
        return coder.encodedData
    }
}
