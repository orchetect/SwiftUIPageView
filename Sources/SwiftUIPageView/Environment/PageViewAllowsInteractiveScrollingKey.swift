//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

// MARK: - Environment

internal extension EnvironmentValues {
    var isPageViewInteractiveScrollingAllowed: Bool {
        get { self[PageViewAllowsInteractiveScrollingKey.self] }
        set { self[PageViewAllowsInteractiveScrollingKey.self] = newValue }
    }
}

private struct PageViewAllowsInteractiveScrollingKey: EnvironmentKey {
    static let defaultValue = true
}

// MARK: - View Modifiers

extension View {
    /// Enables the the user to interactively scroll a ``PageView``.
    ///
    /// - Parameters:
    ///   - enabled: A Boolean value that determines whether page views can be scrolled by the user.
    public func pageViewAllowsInteractiveScrolling(_ enabled: Bool = true) -> some View {
        environment(\.isPageViewInteractiveScrollingAllowed, enabled)
    }
}
