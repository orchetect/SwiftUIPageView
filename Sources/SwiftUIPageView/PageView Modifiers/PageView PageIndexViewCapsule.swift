//
//  PageView PageIndexViewCapsule.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

extension PageView {
    /// Apply a capsule around a ``PageIndexView``.
    ///
    /// - Parameters:
    ///   - color: Capsule color. If `nil`, an appropriate default color will be used.
    public func pageIndexViewCapsule(
        _ color: Color? = nil
    ) -> PageView {
        var copy = self
        copy.indexViewHasCapsule = true
        copy.indexViewCapsuleColor = color
        return copy
    }
}
