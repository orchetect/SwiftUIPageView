//
//  PageIndexView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

/// A view that mimics page index control often seen on iOS,
/// with custom axis and optional support for user interaction.
///
/// View will dim when `isEnabled` environment value is `false`.
public struct PageIndexView: View {
    @Environment(\.isEnabled) private var isEnabled
    
    var axis: Axis
    var indexRange: Range<Int>
    @Binding private var index: Int
    var allowsUserInteraction: Bool
    var scaling: CGFloat
    var style: PageIndexViewStyle = .init()
    
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
        scaling: CGFloat = 1.0
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

// MARK: - Utilities

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
