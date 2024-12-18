//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import Foundation
import CoreGraphics

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
        case .custom(let customDistance): return customDistance
        }
    }
    
    public var name: String {
        switch self {
        case .short: return "Short"
        case .medium: return "Medium"
        case .long: return "Long"
        case .custom(let customDistance): return "\(customDistance) pts"
        }
    }
}
