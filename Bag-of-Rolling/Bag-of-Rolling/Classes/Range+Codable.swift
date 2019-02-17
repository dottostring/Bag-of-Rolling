//
//  Range+Codable.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/17/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//


extension Range: Codable where Bound: Codable {
    private enum CodingKeys: CodingKey {
        case lowerBound
        case upperBound
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lowerBound = try container.decode(Bound.self, forKey: .lowerBound)
        let upperBound = try container.decode(Bound.self, forKey: .upperBound)
        self.init(uncheckedBounds: (lower: lowerBound, upper: upperBound))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.lowerBound, forKey: .lowerBound)
        try container.encode(self.upperBound, forKey: .upperBound)
    }
}
