//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

extension View {
    /// Apply a mask that fades the view's edges along an axis.
    ///
    /// - Parameters:
    ///   - axis: Axis for gradient.
    ///   - inset: Edge inset distance as a floating-point unit interval between zero and midpoint (0.0 ... 0.5).
    ///     Out-of-bounds values will be clamped.
    func opacityFadeMask(_ axis: Axis, inset: CGFloat = 0.2) -> some View {
        // clamp from 0 to midpoint
        let clampedInset = max(min(inset, 0.5), 0.0)
        
        let gradient = LinearGradient(
            stops: [
                .init(color: .clear, location: 0.0),
                .init(color: .black, location: clampedInset),
                .init(color: .black, location: 1.0 - clampedInset),
                .init(color: .clear, location: 1.0)
            ],
            startPoint: axis == .horizontal ? .leading : .top,
            endPoint: axis == .horizontal ? .trailing : .bottom
        )
        
        // use newer API when available
        if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *) {
            return mask { gradient }
        } else {
            return mask(gradient)
        }
    }
}
