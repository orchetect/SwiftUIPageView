//
//  DragAnimator.swift
//  SwiftUIPageView • https://github.com/orchetect/SwiftUIPageView
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct DragAnimator: AnimatableModifier {
    @State private var workItem: DispatchWorkItem? = nil

    var animatableData: CGFloat
    var computedOffset: CGFloat
    var pageState: PageState

    init(computedOffset: CGFloat, pageState: PageState) {
        animatableData = computedOffset
        self.computedOffset = computedOffset
        self.pageState = pageState
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: animatableData) { animatableData in
                if workItem != nil {
                    workItem?.cancel()
                    workItem = nil
                }

                switch pageState.dragState {
                case .dragging, .ended:
                    return

                case .ending, .nearlyEnded:
                    pageState.offset = animatableData

                    if animatableData == computedOffset {
                        let computedOffset = computedOffset
                        let workItem = DispatchWorkItem {
                            if computedOffset == self.computedOffset {
                                pageState.dragState = .ended
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                        self.workItem = workItem
                    } else if abs(animatableData - computedOffset) < 2.5 {
                        if pageState.dragState != .nearlyEnded {
                            pageState.dragState = .nearlyEnded
                        }
                    } else {
                        if pageState.dragState != .ending {
                            pageState.dragState = .ending
                        }
                    }
                }
            }
    }
}
