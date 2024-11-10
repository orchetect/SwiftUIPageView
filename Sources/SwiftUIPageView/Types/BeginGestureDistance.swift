//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import Foundation
import CoreGraphics

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
        case .custom(let customDistance): return customDistance
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
        case .custom(let customDistance): return "\(customDistance) pts"
        }
    }
}
