//
//  RandomInt.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/8/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//

import Foundation

class RandomInt: Codable {
    class func value(_ from: Int, to: Int) -> Int {
        let (lowerLimit, higherLimit) = from < to ? (from, to) : (to, from)
        if lowerLimit == higherLimit {
            return lowerLimit
        }
        let range = higherLimit - lowerLimit + 1
        return lowerLimit + Int(arc4random_uniform(UInt32(range)))
    }
}
