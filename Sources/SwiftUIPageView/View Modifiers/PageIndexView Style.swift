//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

// MARK: - Style

// note: can't call this PageIndexViewStyle because SwiftUI has a native type with that name.
/// Style for ``PageIndexView``.
public protocol PageIndexViewStyleProtocol where Self: Equatable, Self: Hashable, Self: Sendable {
    /// The color for the currently active index.
    var activeColor: Color { get }
    
    /// The color for the inactive indices.
    var inactiveColor: Color { get }
    
    /// Dot size in points.
    var dotSize: CGFloat { get }
    
    /// Spacing between dots in points.
    var spacing: CGFloat { get }
    
    /// Scaling factor.
    var scaling: CGFloat { get }
}

/// Default style for ``PageIndexView``.
public struct DefaultPageIndexViewStyle: PageIndexViewStyleProtocol {
    public let activeColor: Color = .primary
    public let inactiveColor: Color = .secondary
    public let dotSize: CGFloat = 6
    public let spacing: CGFloat = 8
    public let scaling: CGFloat = 1.0
    
    public init() { }
}

/// Custom style for ``PageIndexView``.
private struct CustomPageIndexViewStyle: PageIndexViewStyleProtocol {
    let activeColor: Color
    let inactiveColor: Color
    let dotSize: CGFloat
    let spacing: CGFloat
    let scaling: CGFloat
    
    init(
        activeColor: Color? = nil,
        inactiveColor: Color? = nil,
        dotSize: CGFloat? = nil,
        spacing: CGFloat? = nil,
        scaling: CGFloat? = nil
    ) {
        let defaultStyle = DefaultPageIndexViewStyle()
        
        self.activeColor = activeColor ?? defaultStyle.activeColor
        self.inactiveColor = inactiveColor ?? defaultStyle.inactiveColor
        self.dotSize = dotSize ?? defaultStyle.dotSize
        self.spacing = spacing ?? defaultStyle.spacing
        self.scaling = scaling ?? defaultStyle.scaling
    }
}

// MARK: - Environment

extension EnvironmentValues {
    var pageViewIndexStyle: any PageIndexViewStyleProtocol {
        get { self[PageIndexViewStyleKey.self] }
        set { self[PageIndexViewStyleKey.self] = newValue }
    }
}

private struct PageIndexViewStyleKey: EnvironmentKey {
    static let defaultValue: any PageIndexViewStyleProtocol = DefaultPageIndexViewStyle()
}

// MARK: - View Modifiers

extension View {
    /// Apply a style to a ``PageIndexView`` or a ``PageView``'s index display.
    public func pageViewIndexStyle(_ style: any PageIndexViewStyleProtocol) -> some View {
        environment(\.pageViewIndexStyle, style)
    }
    
    /// Apply a style to a ``PageIndexView`` or a ``PageView``'s index display.
    ///
    /// - Parameters:
    ///   - activeColor: The color for the currently active index.
    ///   - inactiveColor: The color for the inactive indices.
    ///   - dotSize: Dot size in points.
    ///   - spacing: Spacing between dots in points.
    ///   - scaling: Scaling factor.
    public func pageViewIndexStyle(
        activeColor: Color? = nil,
        inactiveColor: Color? = nil,
        dotSize: CGFloat? = nil,
        spacing: CGFloat? = nil,
        scaling: CGFloat? = nil
    ) -> some View {
        let style = CustomPageIndexViewStyle(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            dotSize: dotSize,
            spacing: spacing,
            scaling: scaling
        )
        return environment(\.pageViewIndexStyle, style)
    }
}
