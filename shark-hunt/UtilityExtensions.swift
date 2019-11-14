//
//  UtilityExtensions.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/14/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

extension Double {
    func easyToReadTimeNotation(withDecimalPlaces decimalPlaces: Int) -> String {
        
        // 9_223_372_036_854_775_807
        let dividesSuffix = [(86_400, "D"), (3600, "H"), (60, "M"), (1, "S")]
        //let divides = [1_000_000_000_000_000, 1_000_000_000_000, 1_000_000_000, 1_000_000 ,1000, 1]
        
        for (divider, suffix) in dividesSuffix {
            if self / Double(divider) >= 1.0 {
                let numerical: Double = Double(self) / Double(divider)
                return String(numerical.customRounded(withDecimalPlaces: decimalPlaces)) + suffix
            }
        }
        
        return String(self.customRounded(withDecimalPlaces: decimalPlaces))
    }
}

extension Double {
    func customRounded(withDecimalPlaces decimalPlaces: Int) -> Double {
        var s = self
        s *= Double(10.raisedToPower(decimalPlaces))
        s.round()
        s /= Double(10.raisedToPower(decimalPlaces))
        return s
    }
}

extension Int {
    func easyToReadNotation(withDecimalPlaces decimalPlaces: Int) -> String {
        
        // 9_223_372_036_854_775_807
        let dividesSuffix = [(1_000_000_000_000_000, "Q"), (1_000_000_000_000, "T"), (1_000_000_000, "B"), (1_000_000, "M"), (1_000, "K")]
        //let divides = [1_000_000_000_000_000, 1_000_000_000_000, 1_000_000_000, 1_000_000 ,1000, 1]
        
        for (divider, suffix) in dividesSuffix {
            if self / divider > 0 {
                let numerical: Double = Double(self) / Double(divider)
                return String(numerical.customRounded(withDecimalPlaces: decimalPlaces)) + suffix
            }
        }
        return String(self)
    }
}


extension Double {
    func easyToReadNotation(withDecimalPlaces decimalPlaces: Int) -> String {
        
        // 9_223_372_036_854_775_807
        let dividesSuffix = [(1_000_000_000_000_000, "Q"), (1_000_000_000_000, "T"), (1_000_000_000, "B"), (1_000_000, "M"), (1_000, "K")]
        //let divides = [1_000_000_000_000_000, 1_000_000_000_000, 1_000_000_000, 1_000_000 ,1000, 1]
        
        for (divider, suffix) in dividesSuffix {
            if self / Double(divider) >= 1.0 {
                let numerical = self / Double(divider)
                return String(numerical.customRounded(withDecimalPlaces: decimalPlaces)) + suffix
            }
        }
        
        return String(self.customRounded(withDecimalPlaces: decimalPlaces))
    }
}

extension Int {
    func raisedToPower(_ exponent: Int) -> Int {
        let base = self
        var newValue = self
        
        for _ in 1..<exponent {
            newValue *= base
        }
        
        return newValue
    }
}

