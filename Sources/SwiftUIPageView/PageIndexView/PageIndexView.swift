//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

#if !os(tvOS)

import SwiftUI

/// A view that mimics the page index control often seen on iOS oriented on the specified axis, with support for user interaction.
///
/// To attach an index display to a ``PageView``, use the ``pageViewIndexDisplay(edge:position:indexRange:allowsUserInteraction:)`` view modifier instead.
///
/// View will dim when `isEnabled` environment value is `false`.
public struct PageIndexView: View {
    @Environment(\.isEnabled) private var isEnabled
    
    @Environment(\.pageIndexViewStyle) var pageIndexViewStyle
    @Environment(\.pageIndexViewCapsuleOptions) var pageIndexViewCapsuleOptions
    
    var axis: Axis
    var indexRange: Range<Int>
    @Binding private var index: Int
    var allowsUserInteraction: Bool
    
    /// A view that mimics page index control often seen on iOS,
    /// with custom axis and optional support for user interaction.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this page view.
    ///   - indexRange: Page index range of the ``PageView``.
    ///   - index: A binding to get and set the current page index.
    ///   - allowsUserInteraction: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.
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
        if let pageIndexViewCapsuleOptions = pageIndexViewCapsuleOptions {
            CapsuleView(
                axis: axis,
                color: pageIndexViewCapsuleOptions.color,
                pageIndexView: pageIndexBody
            )
        } else {
            pageIndexBody
        }
    }
    
    @ViewBuilder
    public var pageIndexBody: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: pageIndexViewStyle.spacing * pageIndexViewStyle.scaling) {
                dots
            }
        case .vertical:
            VStack(spacing: pageIndexViewStyle.spacing * pageIndexViewStyle.scaling) {
                dots
            }
        }
    }
    
    private var dots: some View {
        ForEach(indexRange, id: \.self) { idx in
            Circle()
                .fill(dotColor(forIndex: idx))
                .frame(width: pageIndexViewStyle.dotSize * pageIndexViewStyle.scaling,
                       height: pageIndexViewStyle.dotSize * pageIndexViewStyle.scaling)
                .animation(.spring(), value: index == idx)
                .onTapGesture { onTap(tappedIndex: idx) }
        }
    }
    
    private func dotColor(forIndex idx: Int) -> Color {
        var baseColor = index == idx ? pageIndexViewStyle.activeColor : pageIndexViewStyle.inactiveColor
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

// MARK: - Utilities

extension PageIndexView {
    /// Utility to calculate ``PageIndexView`` dot thickness.
    internal static func thickness(dotSize: CGFloat, scaling: CGFloat) -> CGFloat {
        dotSize * scaling
    }
    
    /// Utility to calculate ``PageIndexView`` total thickness.
    internal static func totalThickness(dotSize: CGFloat, scaling: CGFloat, hasCapsule: Bool) -> CGFloat {
        let padding = hasCapsule ? PageIndexView.CapsuleView<EmptyView>.thicknessPadding(dotSize: dotSize, scaling: scaling) * 2 : 0
        let dots = thickness(dotSize: dotSize, scaling: scaling)
        return padding + dots
    }
}

#endif
