//
//  Roll.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/8/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//

struct Roll: Codable {
    let rolls: [SingleRoll]
    let modifiers: [ValueModifier]

    init(rolls: [SingleRoll],
         modifiers: [ValueModifier] = []) {
        self.rolls = rolls
        self.modifiers = modifiers
    }

    func cast() -> Int {
        var val: Double = 0
        rolls.forEach {val += Double($0.throwCastable())}
        modifiers.forEach {val = $0.modify(result: val)}
        return Int(val.rounded(.down))
    }

    func best(of: Int) -> Int {
        return (0..<of).map({_ in cast()}).max() ?? 0
    }

    func worst(of: Int) -> Int {
        return (0..<of).map({_ in cast()}).min() ?? 0
    }
}

struct SingleRoll: Codable {
    let castable: Castable
    let modifiers: [ValueModifier]

    init(castable: Castable,
         modifiers: [ValueModifier] = []) {
        self.castable = castable
        self.modifiers = modifiers
    }

    func throwCastable() -> Int {
        return castable.cast(with: modifiers)
    }

    func best(of: Int) -> Int {
        return (0..<of).map({_ in throwCastable()}).max() ?? 0
    }

    func worst(of: Int) -> Int {
        return (0..<of).map({_ in throwCastable()}).min() ?? 0
    }
}
