//
//  PageIndexView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

// MARK: - PageIndexView

/// A view that mimics page index control often seen on iOS, 
/// with custom axis and optional support for user interaction.
///
/// View will dim when `isEnabled` environment value is `false`.
public struct PageIndexView: View {
    @Environment(\.isEnabled) private var isEnabled
    
    internal var axis: Axis
    internal var indexRange: Range<Int>
    @Binding private var index: Int
    private var allowsUserInteraction: Bool
    internal var style: PageIndexViewStyle = .init()
    
    public init(
        _ axis: Axis,
        indexRange: Range<Int>,
        index: Binding<Int>,
        allowsUserInteraction: Bool = true
    ) {
        self.axis = axis
        self.indexRange = indexRange
        self._index = index
        self.allowsUserInteraction = allowsUserInteraction
    }
    
    public var body: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: style.spacing) {
                dots
            }
        case .vertical:
            VStack(spacing: style.spacing) {
                dots
            }
        }
    }
    
    private var dots: some View {
        ForEach(indexRange, id: \.self) { idx in
            Circle()
                .fill(dotColor(forIndex: idx))
                .frame(width: style.dotSize, height: style.dotSize)
                .animation(.spring(), value: index == idx)
                .onTapGesture { onTap(tappedIndex: idx) }
        }
    }
    
    private func dotColor(forIndex idx: Int) -> Color {
        var baseColor = index == idx ? style.activeColor : style.inactiveColor
        if !isEnabled {
            baseColor = baseColor.opacity(0.5)
        }
        return baseColor
    }
    
    private func onTap(tappedIndex idx: Int) {
        guard isEnabled, allowsUserInteraction else { return }
        index = idx
    }
}

// MARK: - PageIndexViewStyle

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

// MARK: - Background

extension PageIndexView {
    /// Apply a capsule around a ``PageIndexView``.
    public func pageIndexViewCapsule(_ color: Color? = nil, scaling: CGFloat = 1.0) -> some View {
        PageIndexCapsuleView(color: color, scaling: scaling, content: self)
    }
}

// MARK: - PageIndexCapsuleView

/// A capsule view useful for ``PageIndexView`` background.
///
/// View will dim when `isEnabled` environment value is `false`.
internal struct PageIndexCapsuleView: View {
    @Environment(\.isEnabled) private var isEnabled
    
    private var color: Color?
    private var scaling: CGFloat
    private var content: PageIndexView
    
    public init(color: Color?, scaling: CGFloat, content: PageIndexView) {
        self.color = color
        self.scaling = scaling
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize), style: .continuous)
                .fill(fillColor)
                
            content
                .padding( // end-cap padding
                    content.axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                    content.style.spacing
                )
                .padding( // depth padding
                    content.axis == .horizontal ? [.top, .bottom] : [.leading, .trailing],
                    content.style.dotSize
                )
                .fixedSize()
        }
        .fixedSize()
        .scaleEffect(CGSize(width: scaling, height: scaling), anchor: .center)
    }
    
    private var cornerSize: CGFloat {
        content.style.dotSize * 2
    }
    
    private var fillColor: Color {
        #if os(macOS)
        let defaultColor = Color(NSColor.scrubberTexturedBackground)
        #elseif os(iOS)
        let defaultColor = Color(UIColor.tertiarySystemBackground)
        #endif
        
        var baseColor = color ?? defaultColor
        if !isEnabled {
            baseColor = baseColor.opacity(0.5)
        }
        return baseColor
    }
}
