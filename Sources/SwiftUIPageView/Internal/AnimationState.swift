//  SwiftUIPageView
//  Copyright (c) 2022 Ciaran O'Brien
//  MIT license, see LICENSE file for details

import SwiftUI

internal class AnimationState: ObservableObject {
    var dragAnimation: Animation? = nil
    var viewAnimation: Animation? = nil
    var viewAnimationCanUpdate = true
}
