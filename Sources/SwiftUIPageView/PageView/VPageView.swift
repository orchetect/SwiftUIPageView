//  SwiftUIPageView
//  Copyright (c) 2022 Ciaran O'Brien
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

#if !os(tvOS)

import SwiftUI

/// A view that arranges its children in a vertical line with page scrolling and an optional index display.
public struct VPageView<Content: View>: View {
    var alignment: Alignment
    var pageLength: CGFloat?
    var spacing: CGFloat?
    var beginGestureDistance: BeginGestureDistance
    var minGestureDistance: MinimumGestureDistance
    var fadeScrollEdgesInset: CGFloat?
    var selection: Binding<Int>?
    var content: () -> Content
    
    public var body: some View {
        PageView(
            .vertical,
            alignment: alignment,
            pageLength: pageLength,
            spacing: spacing,
            beginGestureDistance: beginGestureDistance,
            minGestureDistance: minGestureDistance,
            fadeScrollEdgesInset: fadeScrollEdgesInset,
            selection: selection,
            content: content
        )
    }
    
    /// A view that arranges its children in a vertical line with page scrolling and an optional index display.
    ///
    /// This view returns a flexible preferred size to its parent layout.
    ///
    /// Changes to the layout axis will cause the pages to lose any internal
    /// state, and will not be animated.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the pages in this page view.
    ///   - pageLength: The length of each page, parallel to the layout axis,
    ///     or `nil` if you want each page to fill the length of the page view.
    ///   - spacing: The distance between adjacent pages, or `nil` if you
    ///     want the page view to choose a default distance for each pair of
    ///     pages.
    ///   - beginGestureDistance: Minimum swipe distance before a swipe gesture begins.
    ///   - minGestureDistance: Minimum swipe distance before advancing to the previous or next page.
    ///     Lower values increase sensitivity.
    ///   - fadeScrollEdgesInset: Apply an alpha fade on the scroll edges of the view with the given inset amount.
    ///   - selection: An optional binding to get and set the current page index.
    ///   - content: A view builder that creates the content of this page view.
    public init(
        alignment: HorizontalAlignment = .center,
        pageLength: CGFloat? = nil,
        spacing: CGFloat? = nil,
        beginGestureDistance: BeginGestureDistance = .short,
        minGestureDistance: MinimumGestureDistance = .short,
        fadeScrollEdgesInset: CGFloat? = nil,
        selection: Binding<Int>? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment.alignment
        self.pageLength = pageLength
        self.spacing = spacing
        self.beginGestureDistance = beginGestureDistance
        self.minGestureDistance = minGestureDistance
        self.fadeScrollEdgesInset = fadeScrollEdgesInset
        self.selection = selection
        self.content = content
    }
}

#endif
