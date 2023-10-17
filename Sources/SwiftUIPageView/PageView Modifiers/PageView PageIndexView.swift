//
//  PageView PageIndexView.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

extension PageView {
    /// Attach an index view to the page view.
    ///
    /// - Parameters:
    ///   - edge: Edge to attach the index view. If `nil`, its position will be automatic based on the page view's axis.
    ///   - position: Position for the index view. Can be inside (overlay), external, or a custom offset.
    ///   - indexRange: Page index range of the ``PageView``.
    ///   - allowsUserInteraction: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.
    ///   - scaling: Scaling factor.
    public func pageIndexView(
        edge: Edge? = nil,
        position: PageIndexView.EdgeOffset = .inside,
        indexRange: Range<Int>,
        allowsUserInteraction: Bool = true,
        scaling: CGFloat = 1.0
    ) -> PageView {
        var copy = self
        copy.hasIndexView = true
        copy.indexViewEdge = edge
        copy.indexViewPosition = position
        copy.indexViewIndexRange = indexRange
        copy.indexViewAllowsUserInteraction = allowsUserInteraction
        copy.indexViewScaling = scaling
        return copy
    }
}
