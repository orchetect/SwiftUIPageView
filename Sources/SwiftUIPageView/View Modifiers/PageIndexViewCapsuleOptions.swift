//
//  PageIndexViewCapsuleOptions.swift
//  SwiftUIPageView
//
//  Created by Steffan Andrews on 2023-10-14.
//

import SwiftUI

// MARK: - Options

struct PageIndexViewCapsuleOptions {
    let color: Color?
}

// MARK: - Environment

extension EnvironmentValues {
    var pageIndexViewCapsuleOptions: PageIndexViewCapsuleOptions? {
        get { self[PageIndexViewCapsuleOptionsKey.self] }
        set { self[PageIndexViewCapsuleOptionsKey.self] = newValue }
    }
}

private struct PageIndexViewCapsuleOptionsKey: EnvironmentKey {
    static let defaultValue: PageIndexViewCapsuleOptions? = nil
}

// MARK: - View Modifiers

extension View {
    /// Apply a capsule around a ``PageIndexView`` or a ``PageView``'s index display.
    func pageIndexViewCapsule(
        options: PageIndexViewCapsuleOptions
    ) -> some View {
        environment(\.pageIndexViewCapsuleOptions, options)
    }
    
    /// Apply a capsule around a ``PageIndexView`` or a ``PageView``'s index display.
    ///
    /// - Parameters:
    ///   - color: Capsule color. If `nil`, an appropriate default color will be used.
    public func pageIndexViewCapsule(
        _ color: Color? = nil
    ) -> some View {
        let options = PageIndexViewCapsuleOptions(
            color: color
        )
        return environment(\.pageIndexViewCapsuleOptions, options)
    }
}
