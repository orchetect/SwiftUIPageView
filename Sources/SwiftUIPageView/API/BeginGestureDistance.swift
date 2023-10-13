//
//  BeginGestureDistance.swift
//  SwiftUIPageView
//
//  Created by Tomas Kafka on 27.06.2022.
//

import Foundation
import CoreGraphics

/// Minimum distance swipe distance before a swipe gesture begins.
public enum BeginGestureDistance {
    case immediate
    case short
    case medium
    case long
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .immediate: return 0
        case .short: return 5
        case .medium: return 15
        case .long: return 31
        case .custom(let customDistance): return customDistance
        }
    }
}
