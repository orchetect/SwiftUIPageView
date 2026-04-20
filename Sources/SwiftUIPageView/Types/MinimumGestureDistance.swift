//
//  MinimumGestureDistance.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import CoreGraphics
import Foundation

/// Minimum swipe distance before advancing to the previous or next page.
/// Lower values increase sensitivity.
public enum MinimumGestureDistance {
    case short
    case medium
    case long

    /// Specify a custom value in points.
    case custom(CGFloat)

    static let zero: Self = .custom(0)
}

extension MinimumGestureDistance: Equatable { }

extension MinimumGestureDistance: Hashable { }

extension MinimumGestureDistance: Sendable { }

extension MinimumGestureDistance {
    var value: CGFloat {
        switch self {
        case .short: return 5
        case .medium: return 30
        case .long: return 60
        case let .custom(customDistance): return customDistance
        }
    }

    public var name: String {
        switch self {
        case .short: return "Short"
        case .medium: return "Medium"
        case .long: return "Long"
        case let .custom(customDistance): return "\(customDistance) pts"
        }
    }
}
