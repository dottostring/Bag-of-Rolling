//
//  GenericError.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/17/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//

enum GenericError: Error, Codable {
    case custom(string: String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedStringRep = try? container.decode(String.self) {
            self = .custom(string: decodedStringRep)
        } else {
            throw GenericError.custom(string: "Cannot decode Value Modifier")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .custom(let string): try container.encode(string)
        }
    }
}
