//
//  PageIndexView EdgeOffset.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

extension PageIndexView {
    /// Edge offset for ``pageViewIndexDisplay(edge:position:indexRange:allowsUserInteraction:scaling:)``
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
