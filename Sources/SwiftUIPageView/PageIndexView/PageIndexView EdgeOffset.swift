//
//  PageIndexView EdgeOffset.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

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

extension PageIndexView.EdgeOffset: Equatable { }

extension PageIndexView.EdgeOffset: Hashable { }

extension PageIndexView.EdgeOffset: Sendable { }

extension PageIndexView.EdgeOffset: Identifiable {
    public var id: Int {
        hashValue
    }
}

#endif
