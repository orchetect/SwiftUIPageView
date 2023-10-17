//
//  PageAndIndexView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

/// Utility view to layout a ``PageView`` and ``PageIndexView``.
struct PageAndIndexView<PageViewContent: View, PageIndexViewContent: View>: View {
    var edge: Edge?
    var position: PageIndexView.EdgeOffset
    var pageViewContent: PageViewContent
    var pageIndexViewContent: PageIndexViewContent
        
    // PageView attributes
    var axis: Axis
    var pageLength: CGFloat?
        
    // PageIndexView attributes
    @Environment(\.pageIndexViewStyle) var pageIndexViewStyle
    var indexViewScaling: CGFloat
    
    // PageIndexView capsule attributes
    var indexViewHasCapsule: Bool
        
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
            dotSize: pageIndexViewStyle.dotSize,
            scaling: indexViewScaling,
            hasCapsule: indexViewHasCapsule
        ) * 2
            
        switch position {
        case .inside: return -padding
        case .outside: return padding + thickness
        case let .custom(offset): return offset
        }
    }
}
