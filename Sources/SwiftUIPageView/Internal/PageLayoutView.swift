//
//  PageLayoutView.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct PageLayoutView<Content: View>: View {
    var alignment: Alignment
    var animationState: AnimationState
    var axis: Axis
    var content: () -> Content
    var pageLength: CGFloat
    var pageState: PageState
    var spacing: CGFloat
    var viewLength: CGFloat

    var body: some View {
        Group {
            switch axis {
            case .horizontal:
                HStack(alignment: alignment.vertical, spacing: spacing) {
                    content()
                        .frame(width: pageLength)
                }
                .modifier(ViewCounter(
                    animationState: animationState,
                    axis: axis,
                    pageLength: pageLength,
                    pageState: pageState,
                    spacing: spacing
                ))
                .frame(width: viewLength, alignment: .leading)

            case .vertical:
                VStack(alignment: alignment.horizontal, spacing: spacing) {
                    content()
                        .frame(height: pageLength)
                }
                .modifier(ViewCounter(
                    animationState: animationState,
                    axis: axis,
                    pageLength: pageLength,
                    pageState: pageState,
                    spacing: spacing
                ))
                .frame(height: viewLength, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
