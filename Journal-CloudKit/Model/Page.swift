//
//  Page.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct Page: Codable, Hashable {
    
    var id: Identifier<Page>
    var title: String
    var createdAt: Date
    var text: String
    
}
