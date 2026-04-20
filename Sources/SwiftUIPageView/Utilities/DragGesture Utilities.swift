//
//  DragGesture Utilities.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS)

import SwiftUI

extension DragGesture.Value {
    var velocity: CGSize {
        CGSize(
            width: (predictedEndTranslation.width - translation.width) * 4,
            height: (predictedEndTranslation.height - translation.height) * 4
        )
    }
}

#endif
