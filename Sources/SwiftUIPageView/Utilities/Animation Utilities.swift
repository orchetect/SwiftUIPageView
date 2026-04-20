//
//  Animation Utilities.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension Animation {
    static func dragEnded(distance: CGFloat, velocity: CGFloat, viewLength: CGFloat) -> Animation {
        let mass: CGFloat = 1
        let stiffness: CGFloat = 250
        let dampingRatio: CGFloat = 1

        let damping = 2 * dampingRatio * sqrt(mass * stiffness)
        let initialVelocity: CGFloat

        if abs(velocity) < .velocityThreshold {
            initialVelocity = sqrt(abs(distance * 200 / viewLength))
        } else if distance == 0 {
            initialVelocity = 0
        } else {
            initialVelocity = velocity / distance
        }

        return .interpolatingSpring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )
    }

    static let dragStarted = Animation.linear(duration: 0)
}
