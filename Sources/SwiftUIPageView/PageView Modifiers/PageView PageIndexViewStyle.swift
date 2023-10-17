//
//  PageView PageIndexViewStyle.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

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
