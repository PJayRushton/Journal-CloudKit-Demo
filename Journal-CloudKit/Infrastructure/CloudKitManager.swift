//
//  CloudKitManager.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/19/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation
import CloudKit
import UIKit


struct CloudKitManager {
    
    let container = CKContainer.default()
    var privateDB: CKDatabase {
        return container.privateCloudDatabase
    }
    
    func fetchRecords(ofType type: String, predicate: NSPredicate = NSPredicate(value: true), completion: @escaping (([CKRecord]?) -> Void)) {
        let query = CKQuery(recordType: type, predicate: predicate)
        privateDB.perform(query, inZoneWith: CKRecordZone.ID.default) { (records, error) in
            completion(records)
        }
    }
    
    func saveRecord(_ record: CKRecord, completion: ((CKError?) -> Void)? = nil) {
        privateDB.save(record) { record, error in
            if let error = error as? CKError {
                dump(error)
                if error.code == CKError.Code.notAuthenticated {
                    self.presentUnauthenticatedAlert()
                }
            } else {
                dump("Record Saved")
                dump(record)
            }
            completion?(error as? CKError)
        }
    }
    
    func deleteRecord(_ record: CKRecord, completion: ((Error?) -> Void)? = nil) {
        privateDB.delete(withRecordID: record.recordID) { id, error in
            completion?(error)
        }
    }
    
}


extension CloudKitManager {
    
    func presentUnauthenticatedAlert() {
        DispatchQueue.main.async {
            let top = UIApplication.shared.keyWindow?.rootViewController
            let alert = UIAlertController(title: "iCloud Error", message: "You'll need to authenticate to iCloud", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            top?.present(alert, animated: true, completion: nil)
        }
    }
    
}
