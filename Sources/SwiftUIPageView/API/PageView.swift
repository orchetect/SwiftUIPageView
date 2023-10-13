///  SwiftUIPageView
///  Copyright (c) Ciaran O'Brien 2022
///  MIT license, see LICENSE file for details

import SwiftUI

/// A view that arranges its children in a line, and provides paged
/// scrolling behaviour.
public struct PageView<Content>: View
where Content: View {
    @Environment(\.displayScale) var displayScale
    
    public var body: some View {
        GeometryReader { geometry in
            let spacing = spacing ?? 8
            let viewLength = viewLength(for: geometry)
            let pageLength = pageLength(viewLength: viewLength)
            let baseOffset = baseOffset(pageLength: pageLength, viewLength: viewLength)
            
            PageGestureView(
                alignment: alignment,
                axis: axis,
                baseOffset: baseOffset,
                content: content,
                pageLength: pageLength,
                spacing: spacing,
                beginGestureDistance: beginGestureDistance,
                viewLength: viewLength,
                index: $index
            )
        }
        .animation(nil, value: axis)
    }
    
    var axis: Axis
    var alignment: Alignment
    var pageLength: CGFloat?
    var spacing: CGFloat?
    var beginGestureDistance: BeginGestureDistance
    @Binding var index: Int
    var content: () -> Content
}

extension PageView {
    /// A view that arranges its children in a line, and provides paged
    /// scrolling behaviour.
    ///
    /// This view returns a flexible preferred size to its parent layout.
    ///
    /// Changes to the layout axis will cause the pages to lose any internal
    /// state, and will not be animated.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this page view.
    ///   - alignment: The guide for aligning the pages in this page view.
    ///   - pageLength: The length of each page, parallel to the layout axis,
    ///     or `nil` if you want each page to fill the length of the page view.
    ///   - spacing: The distance between adjacent pages, or `nil` if you
    ///     want the page view to choose a default distance for each pair of
    ///     pages.
    ///   - content: A view builder that creates the content of this page view.
    public init(
        _ axis: Axis,
        alignment: PageAlignment<HorizontalPageAlignment, VerticalPageAlignment> = .center,
        pageLength: CGFloat? = nil,
        spacing: CGFloat? = nil,
        beginGestureDistance: BeginGestureDistance = .short,
        index: Binding<Int>? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.alignment = alignment.alignment
        self.pageLength = pageLength
        self.spacing = spacing
        self.beginGestureDistance = beginGestureDistance
        self._index = index ?? .constant(0)
        self.content = content
    }
}
