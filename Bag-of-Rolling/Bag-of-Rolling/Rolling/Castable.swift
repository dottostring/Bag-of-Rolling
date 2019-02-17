//
//  Coin.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/8/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//

import Foundation


enum Castable: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedRange = try? container.decode(Range<Int>.self) {
            self = .range(value: decodedRange)
        } else if let decodedSpecificNumber = try? container.decode(Int.self) {
            self = .specific(number: decodedSpecificNumber)
        } else if let decodedDieString = try? container.decode(String.self) {
            switch decodedDieString {
            case "coin":
                self = .coin
            case "d4":
                self = .fourSidedDie
            case "d6":
                self = .sixSidedDie
            case "d8":
                self = .eightSidedDie
            case "d10":
                self = .tenSidedDie
            case "d12":
                self = .twelveSidedDie
            case "d20":
                self = .twentySidedDie
            case "d100":
                self = .percentileDie
            default:
                throw GenericError.custom(string: "Cannot decode Castable")
            }
        } else {
            throw GenericError.custom(string: "Cannot decode Castable")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .coin: try container.encode("coin")
        case .fourSidedDie: try container.encode("d4")
        case .sixSidedDie: try container.encode("d6")
        case .eightSidedDie: try container.encode("d8")
        case .tenSidedDie: try container.encode("d10")
        case .twelveSidedDie: try container.encode("d12")
        case .twentySidedDie: try container.encode("d20")
        case .percentileDie: try container.encode("d100")
        case .range(let value): try container.encode(value)
        case .specific(let number): try container.encode(number)
        }
    }

    var lowerEnd: Int {
        get {
            switch self {
            case .range(let value):
                return value.lowerBound
            case .specific(let number): return number
            default: return 1
            }
        }
    }

    var upperEnd: Int {
        get {
            switch self {
            case .coin: return 2
            case .fourSidedDie: return 4
            case .sixSidedDie: return 6
            case .eightSidedDie: return 8
            case .tenSidedDie: return 10
            case .twelveSidedDie: return 12
            case .twentySidedDie: return 20
            case .percentileDie: return 100
            case .range(let value):
                return value.upperBound
            case .specific(let number): return number
            }
        }
    }

    case coin
    case fourSidedDie, sixSidedDie, eightSidedDie, tenSidedDie, twelveSidedDie, twentySidedDie
    case percentileDie
    case range(value: Range<Int>)
    case specific(number: Int)

    func cast() -> Int {
        return RandomInt.value(lowerEnd, to: upperEnd)
    }

    func cast(numberOfTimes: Int) -> Int {
        return cast() * numberOfTimes
    }

    func cast(with modifiers: [ValueModifier]) -> Int {
        return cast(numberOfTimes: 1, with: modifiers)
    }

    func cast(numberOfTimes: Int, with modifiers: [ValueModifier]) -> Int {
        var casting = Double(cast() * numberOfTimes)
        modifiers.forEach { casting = $0.modify(result: casting) }
        return Int(casting.rounded(.down))
    }
}
