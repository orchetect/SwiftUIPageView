//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

#if !os(tvOS)

import SwiftUI

// MARK: - Options

struct PageIndexViewOptions {
    let edge: Edge?
    let position: PageIndexView.EdgeOffset
    let indexRange: Range<Int>
    let allowsUserInteraction: Bool
}

extension PageIndexViewOptions: Equatable { }

extension PageIndexViewOptions: Hashable { }

extension PageIndexViewOptions: Sendable { }

// MARK: - Environment

extension EnvironmentValues {
    var pageIndexViewOptions: PageIndexViewOptions? {
        get { self[PageIndexViewOptionsKey.self] }
        set { self[PageIndexViewOptionsKey.self] = newValue }
    }
}

private struct PageIndexViewOptionsKey: EnvironmentKey {
    static let defaultValue: PageIndexViewOptions? = nil
}

// MARK: - View Modifiers

extension View {
    /// Attach an interactive index display to a ``PageView``.
    /// 
    /// - Parameters:
    ///   - options: Index display options. If `nil`, the index display is hidden.
    func pageViewIndexDisplay(
        options: PageIndexViewOptions?
    ) -> some View {
        environment(\.pageIndexViewOptions, options)
    }
    
    /// Attach an interactive index display to a ``PageView``.
    ///
    /// - Parameters:
    ///   - edge: Edge to attach the index view. If `nil`, its position will be automatic based on the page view's axis.
    ///   - position: Position for the index view. Can be inside (overlay), external, or a custom offset.
    ///   - indexRange: Page index range of the ``PageView``.
    ///   - allowsUserInteraction: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.
    public func pageViewIndexDisplay(
        edge: Edge? = nil,
        position: PageIndexView.EdgeOffset = .inside,
        indexRange: Range<Int>,
        allowsUserInteraction: Bool = true
    ) -> some View {
        let options = PageIndexViewOptions(
            edge: edge,
            position: position,
            indexRange: indexRange,
            allowsUserInteraction: allowsUserInteraction
        )
        return environment(\.pageIndexViewOptions, options)
    }
}

#endif
