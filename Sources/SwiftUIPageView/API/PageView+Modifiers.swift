//
//  PageView+Modifiers.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

// MARK: - View Modifiers for PageView

extension PageView {
    /// Attach an index view to the page view.
    ///
    /// - Parameters:
    ///   - edge: Edge to attach the index view. If `nil`, its position will be automatic based on the page view's axis.
    ///   - position: Position for the index view. Can be inside (overlay), external, or a custom offset.
    ///   - indexRange: Page index range of the ``PageView``.
    ///   - allowsUserInteraction: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.
    ///   - scaling: Scaling factor.
    public func pageIndexView(
        edge: Edge? = nil,
        position: PageIndexView.EdgeOffset = .inside,
        indexRange: Range<Int>,
        allowsUserInteraction: Bool = true,
        scaling: CGFloat = 1.0
    ) -> PageView {
        var copy = self
        copy.hasIndexView = true
        copy.indexViewEdge = edge
        copy.indexViewPosition = position
        copy.indexViewIndexRange = indexRange
        copy.indexViewAllowsUserInteraction = allowsUserInteraction
        copy.indexViewScaling = scaling
        return copy
    }
}

extension PageView {
    /// Apply a style to a ``PageIndexView``.
    public func pageIndexViewStyle(_ style: PageIndexViewStyle) -> PageView {
        var copy = self
        copy.indexViewStyle = style
        return copy
    }
    
    /// Apply a style to a ``PageIndexView``.
    ///
    /// - Parameters:
    ///   - activeColor: The color for the currently active index.
    ///   - inactiveColor: The color for the inactive indices.
    ///   - dotSize: Dot size in points.
    ///   - spacing: Spacing between dots in points.
    public func pageIndexViewStyle(
        activeColor: Color = .primary,
        inactiveColor: Color = .secondary,
        dotSize: CGFloat = 6,
        spacing: CGFloat = 8
    ) -> PageView {
        var copy = self
        copy.indexViewStyle = PageIndexViewStyle(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            dotSize: dotSize,
            spacing: spacing
        )
        return copy
    }
}

extension PageView {
    /// Apply a capsule around a ``PageIndexView``.
    ///
    /// - Parameters:
    ///   - color: Capsule color. If `nil`, an appropriate default color will be used.
    public func pageIndexViewCapsule(
        _ color: Color? = nil
    ) -> PageView {
        var copy = self
        copy.indexViewHasCapsule = true
        copy.indexViewCapsuleColor = color
        return copy
    }
}
