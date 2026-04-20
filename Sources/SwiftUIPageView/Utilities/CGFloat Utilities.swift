//
//  CGFloat Utilities.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension CGFloat {
    static let velocityThreshold: CGFloat = 200

    func rubberBand(viewLength: CGFloat) -> CGFloat {
        (1 - (1 / ((magnitude * 0.55 / viewLength) + 1))) * viewLength * self / magnitude
    }

    func invertRubberBand(viewLength: CGFloat) -> CGFloat {
        (((1 / (1 - (magnitude / viewLength))) - 1) * viewLength / 0.55) * self / magnitude
    }
}
