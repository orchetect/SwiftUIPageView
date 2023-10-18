//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

// MARK: - Environment

internal extension EnvironmentValues {
    var isPageViewMarginsEnabled: Bool {
        get { self[IsPageViewMarginsEnabledKey.self] }
        set { self[IsPageViewMarginsEnabledKey.self] = newValue }
    }
}

private struct IsPageViewMarginsEnabledKey: EnvironmentKey {
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
