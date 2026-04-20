//
//  AnimationState.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

class AnimationState: ObservableObject {
    var dragAnimation: Animation?
    var viewAnimation: Animation?
    var viewAnimationCanUpdate = true
}
