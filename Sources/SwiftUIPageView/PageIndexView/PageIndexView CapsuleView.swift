//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

extension PageIndexView {
    /// A capsule view useful for ``PageIndexView`` background.
    ///
    /// View will dim when `isEnabled` environment value is `false`.
    internal struct CapsuleView<PageIndexViewContent: View>: View {
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.colorScheme) private var colorScheme
        
        @Environment(\.pageIndexViewStyle) var pageIndexViewStyle
        
        private var axis: Axis
        private var color: Color?
        private var pageIndexView: PageIndexViewContent
        
        init(
            axis: Axis,
            color: Color?,
            pageIndexView: PageIndexViewContent
        ) {
            self.axis = axis
            self.color = color
            self.pageIndexView = pageIndexView
        }
        
        var body: some View {
            ZStack {
                Capsule(style: .continuous)
                    .fill(fillColor)
                
                pageIndexView
                    .padding( // end-cap padding
                        axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                        Self.endCapPadding(dotSize: pageIndexViewStyle.dotSize,
                                           spacing: pageIndexViewStyle.spacing,
                                           scaling: pageIndexViewStyle.scaling)
                    )
                    .padding( // thickness padding
                        axis == .horizontal ? [.top, .bottom] : [.leading, .trailing],
                        Self.thicknessPadding(dotSize: pageIndexViewStyle.dotSize, 
                                              scaling: pageIndexViewStyle.scaling)
                    )
                    .fixedSize()
            }
            .fixedSize()
        }
        
        private var cornerSize: CGFloat {
            pageIndexViewStyle.dotSize * 2
        }
        
        private var fillColor: Color {
            let defaultColor: Color
            switch colorScheme {
            case .dark:
                defaultColor = Color(white: 0.5).opacity(0.5)
            case .light:
                defaultColor = .secondary.opacity(0.5)
            @unknown default:
                defaultColor = Color(white: 0.5).opacity(0.5)
            }
            
            var baseColor = color ?? defaultColor
            if !isEnabled {
                baseColor = baseColor.opacity(0.5)
            }
            return baseColor
        }
    }
}

// MARK: - Utilities

extension PageIndexView.CapsuleView {
    /// Utility to calculate ``PageIndexView`` end-cap padding.
    internal static func endCapPadding(dotSize: CGFloat, spacing: CGFloat, scaling: CGFloat) -> CGFloat {
        let proposed = spacing * scaling
        let minimum = thicknessPadding(dotSize: dotSize, scaling: scaling)
        return max(proposed, minimum)
    }
    
    /// Utility to calculate ``PageIndexView`` thickness padding.
    internal static func thicknessPadding(dotSize: CGFloat, scaling: CGFloat) -> CGFloat {
        dotSize * scaling
    }
}
