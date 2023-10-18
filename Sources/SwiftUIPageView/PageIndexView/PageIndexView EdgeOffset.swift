//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

#if !os(tvOS)

import SwiftUI

extension PageIndexView {
    /// Edge offset for ``pageViewIndexDisplay(edge:position:indexRange:allowsUserInteraction:)``
    public enum EdgeOffset {
        /// Standard inside position.
        case inside
        
        /// Standard outside position.
        case outside
        
        /// Custom edge offset.
        case custom(edgeOffset: CGFloat)
    }
}

extension PageIndexView.EdgeOffset: Hashable {
    // synthesized
}

extension PageIndexView.EdgeOffset: Identifiable {
    public var id: Int { hashValue }
}

#endif
