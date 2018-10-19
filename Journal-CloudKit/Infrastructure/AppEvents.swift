//
//  AppEvents.swift
//  Journal-CloudKit
//
//  Created by Parker Rushton on 10/18/18.
//  Copyright © 2018 Parker Rushton. All rights reserved.
//

import Foundation

struct ObjectAdded<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
}

struct ObjectUpdated<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }

}

struct ObjectDeleted<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
}

struct Selected<T>: Event {
    var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
    
}

struct CreationStarted<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
}

struct CreationFinished<T>: Event {
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
}

struct CreationCancelled<T>: Event { }
