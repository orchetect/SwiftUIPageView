//
//  PageIndexViewStyle.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

/// Style for ``PageIndexView``.
public struct PageIndexViewStyle {
    /// The color for the currently active index.
    public var activeColor: Color
    
    /// The color for the inactive indices.
    public var inactiveColor: Color
    
    /// Dot size in points.
    public var dotSize: CGFloat
    
    /// Spacing between dots in points.
    public var spacing: CGFloat
    
    /// Style for ``PageIndexView``.
    ///
    /// - Parameters:
    ///   - activeColor: The color for the currently active index.
    ///   - inactiveColor: The color for the inactive indices.
    ///   - dotSize: Dot size in points.
    ///   - spacing: Spacing between dots in points.
    public init(
        activeColor: Color = .primary,
        inactiveColor: Color = .secondary,
        dotSize: CGFloat = 6,
        spacing: CGFloat = 8
    ) {
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
        self.spacing = spacing
    }
}

extension PageIndexView {
    /// Apply a style to a ``PageIndexView``.
    public func pageIndexViewStyle(_ style: PageIndexViewStyle) -> PageIndexView {
        var copy = self
        copy.style = style
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
    ) -> PageIndexView {
        var copy = self
        copy.style = PageIndexViewStyle(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            dotSize: dotSize,
            spacing: spacing
        )
        return copy
    }
}
