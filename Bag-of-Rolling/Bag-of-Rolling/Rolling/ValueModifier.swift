//
//  ValueModifier.swift
//  Astral Table
//
//  Created by AlternateAdam on 2/8/19.
//  Copyright © 2019 Cosmic Background Games. All rights reserved.
//

import Foundation
import JavaScriptCore


struct JavascriptTransformFunctionManager {
    enum ScriptVariables: String, Codable, CaseIterable {
        case transformFunction = "transform"
    }

    let javascript: String
}


/// Direct Value Modifier
///
/// - bonus: Add to result
/// - penalty: take away from result
/// - multiply: multiply result by given value
/// - divided: divide result by given value
/// - roundDown: round result down to nearest whole number
/// - roundUp: round result up to nearest whole number
/// - javascript: transform value by running transform function within given javascript
enum ValueModifier: Codable {
    case bonus(value: Double), penalty(value: Double)
    case multiply(by: Double), divided(by: Double)
    case roundDown, roundUp
    case javascript(script: String)

    private struct DoubleValueRep: Codable {
        enum Sign: String, Codable { case bonus = "+", penalty = "-", multiply = "x", divided = "÷" }
        let sign: Sign
        let value: Double
    }

    private struct JavascriptValueRep: Codable { let script: String }
    private enum Rounding: String, Codable { case roundUp, roundDown }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedDoubleRep = try? container.decode(DoubleValueRep.self) {
            switch decodedDoubleRep.sign {
            case .bonus:
                self = .bonus(value: decodedDoubleRep.value)
            case .penalty:
                self = .penalty(value: decodedDoubleRep.value)
            case .multiply:
                self = .multiply(by: decodedDoubleRep.value)
            case .divided:
                self = .divided(by: decodedDoubleRep.value)
            }
        } else if let rounding = try? container.decode(Rounding.self) {
            switch rounding {
            case .roundUp:
                self = .roundUp
            case .roundDown:
                self = .roundDown
            }
        } else if let js = try? container.decode(JavascriptValueRep.self) {
            self = .javascript(script: js.script)
        } else {
            throw GenericError.custom(string: "Cannot decode Value Modifier")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bonus(let value): try container.encode(DoubleValueRep(sign: .bonus, value: value))
        case .penalty(let value): try container.encode(DoubleValueRep(sign: .penalty, value: value))
        case .multiply(let by): try container.encode(DoubleValueRep(sign: .multiply, value: by))
        case .divided(let by): try container.encode(DoubleValueRep(sign: .divided, value: by))
        case .roundUp: try container.encode(Rounding.roundUp)
        case .roundDown: try container.encode(Rounding.roundDown)
        case .javascript(let script): try container.encode(JavascriptValueRep(script: script))
        }
    }


    func modify(result: Double) -> Double {
        switch self {
        case .bonus(let value): return result + value
        case .penalty(let value): return result - value
        case .multiply(let by): return result * by
        case .divided(let by):
            guard result != 0 && by != 0 else { return 0 }
            return result / by
        case .roundDown: return result.rounded(.down)
        case .roundUp: return result.rounded(.up)
        case .javascript(let script):
            guard let context = JSContext(virtualMachine: JSVirtualMachine()) else {
                return result
            }
            context.evaluateScript(script)
            if let trans = context
                .objectForKeyedSubscript(JavascriptTransformFunctionManager.ScriptVariables.transformFunction.rawValue)?
                .call(withArguments: [result])?
                .toDouble() {
                return trans
            } else {
                return result
            }
        }
    }
}

