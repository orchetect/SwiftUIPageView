//
//  BeginGestureDistance.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import CoreGraphics
import Foundation

/// Minimum swipe distance before a swipe gesture begins.
public enum BeginGestureDistance {
    case immediate
    case short
    case medium
    case long

    /// Disallow gestures from changing the page.
    case never

    /// Specify a custom value in points.
    case custom(CGFloat)

    var value: CGFloat {
        switch self {
        case .immediate: return 0
        case .short: return 5
        case .medium: return 15
        case .long: return 31
        case .never: return 100_000
        case let .custom(customDistance): return customDistance
        }
    }
}

extension BeginGestureDistance: Equatable { }

extension BeginGestureDistance: Hashable { }

extension BeginGestureDistance: Sendable { }

extension BeginGestureDistance {
    public var name: String {
        switch self {
        case .immediate: return "Immediate"
        case .short: return "Short"
        case .medium: return "Medium"
        case .long: return "Long"
        case .never: return "Never"
        case let .custom(customDistance): return "\(customDistance) pts"
        }
    }
}
