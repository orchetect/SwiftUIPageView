//
//  PageViewMarginsEnabledKey.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

// MARK: - Environment

extension EnvironmentValues {
    var isPageViewMarginsEnabled: Bool {
        get { self[PageViewMarginsEnabledKey.self] }
        set { self[PageViewMarginsEnabledKey.self] = newValue }
    }
}

private struct PageViewMarginsEnabledKey: EnvironmentKey {
    static let defaultValue = true
}

// MARK: - View Modifiers

extension View {
    /// Enables the use of margins in a ``PageView``.
    ///
    /// - Parameters:
    ///   - enabled: A Boolean value that determines whether page views use margins.
    public func pageViewMarginsEnabled(_ enabled: Bool = true) -> some View {
        environment(\.isPageViewMarginsEnabled, enabled)
    }
}
