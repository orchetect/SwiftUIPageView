//
//  PageIndexView+CapsuleView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

extension PageIndexView {
    /// A capsule view useful for ``PageIndexView`` background.
    ///
    /// View will dim when `isEnabled` environment value is `false`.
    internal struct CapsuleView: View {
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.colorScheme) private var colorScheme
        
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

// MARK: - Utilities

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
