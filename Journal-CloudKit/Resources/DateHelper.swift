//
//  DateHelper.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/20/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct DateHelper {
    static var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}


extension Date {
    
    var mediumString: String {
        return DateHelper.formatter.string(from: self)
    }
    
}
