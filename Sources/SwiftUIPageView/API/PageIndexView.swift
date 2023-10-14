//
//  PageIndexView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

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
    /// Utility view to layout a ``PageView`` and ``PageIndexView``.
    internal struct PageAndIndexView<PageViewContent: View, PageIndexViewContent: View>: View {
        var edge: Edge? = nil
        var position: PageIndexView.EdgeOffset
        var pageViewContent: PageViewContent
        var pageIndexViewContent: PageIndexViewContent
        
        // PageView attributes
        var axis: Axis
        var pageLength: CGFloat?
        
        // PageIndexView attributes
        var indexViewStyle: PageIndexViewStyle
        
        // PageIndexView capsule attributes
        var indexViewHasCapsule: Bool
        var indexViewCapsuleScaling: CGFloat
        
        var body: some View {
            ZStack {
                pageViewContent
                applyIndexViewFrame(adaptingIndexView)
            }
        }
        
        /// Adapt index view to selected axis.
        @ViewBuilder
        private var adaptingIndexView: some View {
            switch indexViewAxis(for: effectiveEdge) {
            case .horizontal:
                Group {
                    VStack {
                        Spacer()
                        pageIndexViewContent
                    }
                }
            case .vertical:
                HStack {
                    pageIndexViewContent
                    Spacer()
                }
            }
        }
        
        @ViewBuilder
        private func applyIndexViewFrame(_ content: some View) -> some View {
            switch indexViewAxis(for: effectiveEdge) {
            case .horizontal:
                if let pageSize = pageLength {
                    content
                        .frame(width: pageSize, height: pageSize + edgeOffset)
                } else {
                    content
                }
            case .vertical:
                if let pageSize = pageLength {
                    content
                        .frame(width: pageSize + edgeOffset, height: pageSize)
                } else {
                    content
                }
            }
        }
        
        private var effectiveEdge: Edge {
            if let edge = edge { return edge }
            switch axis {
            case .horizontal: return .bottom
            case .vertical: return .leading
            }
        }
        
        private func indexViewAxis(for edge: Edge) -> Axis {
            switch edge {
            case .top, .bottom: return .horizontal
            case .leading, .trailing: return .vertical
            }
        }
        
        private var edgeOffset: CGFloat {
            // these values are multiplied by 2 since the return value is used to set a center-origin frame
            
            let padding: CGFloat = 10 * 2
            let thickness = PageIndexView.totalThickness(
                dotSize: indexViewStyle.dotSize,
                scaling: indexViewCapsuleScaling,
                hasCapsule: indexViewHasCapsule
            ) * 2
            
            switch position {
            case .inside: return -padding
            case .outside: return padding + thickness
            case let .custom(offset): return offset
            }
        }
    }
}

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
    internal var allowsUserInteraction: Bool
    internal var scaling: CGFloat
    internal var style: PageIndexViewStyle = .init()
    
    /// A view that mimics page index control often seen on iOS,
    /// with custom axis and optional support for user interaction.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this page view.
    ///   - indexRange: Page index range of the ``PageView``.
    ///   - index: A binding to get and set the current page index.
    ///   - allowsUserInteraction: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.
    ///   - scaling: Scaling factor.
    public init(
        _ axis: Axis,
        indexRange: Range<Int>,
        index: Binding<Int>,
        allowsUserInteraction: Bool = true,
        scaling: CGFloat // = 1.0
    ) {
        self.axis = axis
        self.indexRange = indexRange
        self._index = index
        self.allowsUserInteraction = allowsUserInteraction
        self.scaling = scaling
    }
    
    public var body: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: style.spacing * scaling) {
                dots
            }
        case .vertical:
            VStack(spacing: style.spacing * scaling) {
                dots
            }
        }
    }
    
    private var dots: some View {
        ForEach(indexRange, id: \.self) { idx in
            Circle()
                .fill(dotColor(forIndex: idx))
                .frame(width: style.dotSize * scaling, height: style.dotSize * scaling)
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

// MARK: - Index Capsule Shape

extension PageIndexView {
    /// Apply a capsule around a ``PageIndexView``.
    ///
    /// - Parameters:
    ///   - color: Capsule color. If `nil`, an appropriate default color will be used.
    public func pageIndexViewCapsule(
        _ color: Color? = nil
    ) -> some View {
        CapsuleView(color: color, pageIndexView: self)
    }
}

// MARK: - PageIndexCapsuleView

extension PageIndexView {
    /// A capsule view useful for ``PageIndexView`` background.
    ///
    /// View will dim when `isEnabled` environment value is `false`.
    internal struct CapsuleView: View {
        @Environment(\.isEnabled) private var isEnabled
        
        private var color: Color?
        private var pageIndexView: PageIndexView
        
        init(color: Color?, pageIndexView: PageIndexView) {
            self.color = color
            self.pageIndexView = pageIndexView
        }
        
        var body: some View {
            ZStack {
                Capsule(style: .continuous)
                    .fill(fillColor)
                
                pageIndexView
                    .padding( // end-cap padding
                        pageIndexView.axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                        Self.endcapPadding(dotSize: pageIndexView.style.dotSize, spacing: pageIndexView.style.spacing, scaling: pageIndexView.scaling)
                    )
                    .padding( // thickness padding
                        pageIndexView.axis == .horizontal ? [.top, .bottom] : [.leading, .trailing],
                        Self.thicknessPadding(dotSize: pageIndexView.style.dotSize, scaling: pageIndexView.scaling)
                    )
                    .fixedSize()
            }
            .fixedSize()
        }
        
        private var cornerSize: CGFloat {
            pageIndexView.style.dotSize * 2
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
    
    /// Edge offset for ``pageIndexViewCapsule(edge:_:scaling:)``
    public enum EdgeOffset: Hashable, Identifiable {
        /// Standard inside position.
        case inside
        
        /// Standard outside position.
        case outside
        
        /// Custom edge offset.
        case custom(edgeOffset: CGFloat)
        
        public var id: Int { hashValue }
    }
}

extension PageIndexView.CapsuleView {
    /// Utility to calculate ``PageIndexView`` end-cap padding.
    internal static func endcapPadding(dotSize: CGFloat, spacing: CGFloat, scaling: CGFloat) -> CGFloat {
        let proposed = spacing * scaling
        let minimum = thicknessPadding(dotSize: dotSize, scaling: scaling)
        return max(proposed, minimum)
    }
    
    /// Utility to calculate ``PageIndexView`` thickness padding.
    internal static func thicknessPadding(dotSize: CGFloat, scaling: CGFloat) -> CGFloat {
        dotSize * scaling
    }
}

extension PageIndexView {
    /// Utility to calculate ``PageIndexView`` dot thickness.
    internal static func thickness(dotSize: CGFloat, scaling: CGFloat) -> CGFloat {
        dotSize * scaling
    }
    
    /// Utility to calculate ``PageIndexView`` total thickness.
    internal static func totalThickness(dotSize: CGFloat, scaling: CGFloat, hasCapsule: Bool) -> CGFloat {
        let padding = hasCapsule ? PageIndexView.CapsuleView.thicknessPadding(dotSize: dotSize, scaling: scaling) * 2 : 0
        let dots = thickness(dotSize: dotSize, scaling: scaling)
        return padding + dots
    }
}
