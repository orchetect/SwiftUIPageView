//  SwiftUIPageView
//  Copyright (c) 2022 Ciaran O'Brien
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

/// A view that arranges its children in a line with page scrolling and an optional index display.
public struct PageView<Content: View>: View {
    @Environment(\.displayScale) var displayScale
    
    // page view properties
    var axis: Axis
    var alignment: Alignment
    var pageLength: CGFloat?
    var spacing: CGFloat?
    var beginGestureDistance: BeginGestureDistance
    var minGestureDistance: MinimumGestureDistance
    var fadeScrollEdgesInset: CGFloat?
    @Binding var selection: Int // page index
    var content: () -> Content
    
    // index view properties
    @Environment(\.pageIndexViewOptions) var pageIndexViewOptions
    
    // index view capsule properties
    @Environment(\.pageIndexViewCapsuleOptions) var pageIndexViewCapsuleOptions
    
    public var body: some View {
        applyFadeEdges(to: conditionalIndexBody)
    }
    
    @ViewBuilder
    private var conditionalIndexBody: some View {
        if let pageIndexViewOptions = pageIndexViewOptions {
            let indexView = PageIndexView(
                axis,
                indexRange: pageIndexViewOptions.indexRange,
                index: $selection,
                allowsUserInteraction: pageIndexViewOptions.allowsUserInteraction
            )
            
            PageAndIndexView(
                edge: pageIndexViewOptions.edge,
                position: pageIndexViewOptions.position,
                pageViewContent: pageViewBody,
                pageIndexViewContent: applyCapsuleIfPresent(to: indexView),
                axis: axis,
                pageLength: pageLength
            )
        } else {
            pageViewBody
        }
    }
    
    /* @ViewBuilder */
    private var pageViewBody: some View {
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
                minGestureDistance: minGestureDistance,
                viewLength: viewLength,
                selection: $selection
            )
        }
        .animation(nil, value: axis)
    }
    
    @ViewBuilder
    private func applyCapsuleIfPresent(to view: some View) -> some View {
        if let pageIndexViewCapsuleOptions = pageIndexViewCapsuleOptions {
            view.pageIndexViewCapsule(pageIndexViewCapsuleOptions.color)
        } else {
            view
        }
    }
    
    @ViewBuilder
    private func applyFadeEdges(to view: some View) -> some View {
        if let fadeScrollEdgesInset = fadeScrollEdgesInset {
            view.opacityFadeMask(axis, inset: fadeScrollEdgesInset)
        } else {
            view
        }
    }
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
    ///   - beginGestureDistance: Minimum swipe distance before a swipe gesture begins.
    ///   - minGestureDistance: Minimum swipe distance before advancing to the previous or next page.
    ///     Lower values increase sensitivity.
    ///   - fadeScrollEdgesInset: Apply an alpha fade on the scroll edges of the view with the given inset amount.
    ///   - selection: An optional binding to get and set the current page index.
    ///   - content: A view builder that creates the content of this page view.
    public init(
        _ axis: Axis,
        alignment: Alignment = .center,
        pageLength: CGFloat? = nil,
        spacing: CGFloat? = nil,
        beginGestureDistance: BeginGestureDistance = .short,
        minGestureDistance: MinimumGestureDistance = .short,
        fadeScrollEdgesInset: CGFloat? = nil,
        selection: Binding<Int>? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.alignment = alignment
        self.pageLength = pageLength
        self.spacing = spacing
        self.beginGestureDistance = beginGestureDistance
        self.minGestureDistance = minGestureDistance
        self.fadeScrollEdgesInset = fadeScrollEdgesInset
        self._selection = selection ?? .constant(0)
        self.content = content
    }
}
