//
//  KVBind.swift
//  FFClock
//
//  Created by leo on 24/01/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation

typealias KVAction<T> = (T) -> Void

infix operator =>

class KVBind<T> {
    
    var preActions : [KVAction<T>]
    var actions : [KVAction<T>]
    
    var value : T {
        willSet {
            for preAction in preActions {
                preAction(self.value)
            }
        }
        didSet {
            for action in actions {
                action(self.value)
            }
        }
    }
    
    init(_ v : T) {
        self.value = v
        self.preActions = []
        self.actions = []
    }
    
    static func => (left: KVBind<T>, right: T) {
        left.value = right
    }
}

