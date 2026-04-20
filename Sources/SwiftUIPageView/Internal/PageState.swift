//
//  PageState.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

class PageState: ObservableObject {
    @Published var dragState: DragState = .ended
    @Published var index: CGFloat = 0
    @Published var indexOffset: CGFloat = 0
    @Published var initialIndex: CGFloat? = nil
    var offset: CGFloat = 0
    @Published var viewCount = 0

    let id = UUID()

    enum DragState {
        case dragging
        case ending
        case nearlyEnded
        case ended
    }
}
