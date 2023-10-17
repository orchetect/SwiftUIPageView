//
//  PageIndexViewStyle.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

// MARK: - Style

/// Style for ``PageIndexView``.
public protocol PageIndexViewStyle {
    /// The color for the currently active index.
    var activeColor: Color { get }
    
    /// The color for the inactive indices.
    var inactiveColor: Color { get }
    
    /// Dot size in points.
    var dotSize: CGFloat { get }
    
    /// Spacing between dots in points.
    var spacing: CGFloat { get }
}

/// Default style for ``PageIndexView``.
public struct DefaultPageIndexViewStyle: PageIndexViewStyle {
    public let activeColor: Color = .primary
    public let inactiveColor: Color = .secondary
    public let dotSize: CGFloat = 6
    public let spacing: CGFloat = 8
    
    public init() { }
}

/// Custom style for ``PageIndexView``.
private struct CustomPageIndexViewStyle: PageIndexViewStyle {
    let activeColor: Color
    let inactiveColor: Color
    let dotSize: CGFloat
    let spacing: CGFloat
    
    init(
        activeColor: Color? = nil,
        inactiveColor: Color? = nil,
        dotSize: CGFloat? = nil,
        spacing: CGFloat? = nil
    ) {
        let defaultStyle = DefaultPageIndexViewStyle()
        
        self.activeColor = activeColor ?? defaultStyle.activeColor
        self.inactiveColor = inactiveColor ?? defaultStyle.inactiveColor
        self.dotSize = dotSize ?? defaultStyle.dotSize
        self.spacing = spacing ?? defaultStyle.spacing
    }
}

// MARK: - Environment

extension EnvironmentValues {
    var pageIndexViewStyle: PageIndexViewStyle {
        get { self[PageIndexViewStyleKey.self] }
        set { self[PageIndexViewStyleKey.self] = newValue }
    }
}

private struct PageIndexViewStyleKey: EnvironmentKey {
    static let defaultValue: PageIndexViewStyle = DefaultPageIndexViewStyle()
}

// MARK: - View Modifiers

extension View {
    /// Apply a style to a ``PageIndexView`` or a ``PageView``'s index display.
    public func pageIndexViewStyle(_ style: PageIndexViewStyle) -> some View {
        environment(\.pageIndexViewStyle, style)
    }
    
    /// Apply a style to a ``PageIndexView`` or a ``PageView``'s index display.
    ///
    /// - Parameters:
    ///   - activeColor: The color for the currently active index.
    ///   - inactiveColor: The color for the inactive indices.
    ///   - dotSize: Dot size in points.
    ///   - spacing: Spacing between dots in points.
    public func pageIndexViewStyle(
        activeColor: Color? = nil,
        inactiveColor: Color? = nil,
        dotSize: CGFloat? = nil,
        spacing: CGFloat? = nil
    ) -> some View {
        let style = CustomPageIndexViewStyle(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            dotSize: dotSize,
            spacing: spacing
        )
        return environment(\.pageIndexViewStyle, style)
    }
}
