//
//  PageViewAllowsInteractiveScrollingKey.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

// MARK: - Environment

extension EnvironmentValues {
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
