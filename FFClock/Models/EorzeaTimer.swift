//
//  EorzeaTimer.swift
//  FFClock
//
//  Created by leo on 04/01/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation

let ezMinutePerSecond : Double = 2.0+(11.0/12.0)

public class EorzeaTimer {
    internal init(timeInterval: TimeInterval) {
        self.realTimeinterval = timeInterval
    }
    
    private var changed = false
    
    public var realTimeinterval : TimeInterval = 0.0 {
        didSet {
            changed = true
        }
    }
    
    public var ezMinute : Int8 {
        get {
            return (Int8)((realTimeinterval / ezMinutePerSecond).truncatingRemainder(dividingBy: 60.0))
        }
    }
    
    public var ezBell : Int8 {
        get {
            return (Int8)((realTimeinterval / (ezMinutePerSecond * 60.0)).truncatingRemainder(dividingBy: 24.0))
        }
    }
    
    public var ezSun : Int8 {
        get {
            return (Int8)((realTimeinterval / (ezMinutePerSecond * 60.0 * 24.0)).truncatingRemainder(dividingBy: 8.0))
        }
    }
    
    public var ezSennight : Int8 {
        get {
            return (Int8)((realTimeinterval / (ezMinutePerSecond * 60.0 * 24.0 * 8.0)).truncatingRemainder(dividingBy: 32.0))
        }
    }
    
    public var ezMoon : Int8 {
        get {
            return (Int8)((realTimeinterval / (ezMinutePerSecond * 60.0 * 24.0 * 8.0 * 32.0)).truncatingRemainder(dividingBy: 12.0))
        }
    }
    
    public var ezYear : Int {
        get {
            return (Int)(realTimeinterval / (ezMinutePerSecond * 60.0 * 24.0 * 8.0 * 32.0 * 12.0))
        }
    }
}
