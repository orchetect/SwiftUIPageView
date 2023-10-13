//
//  Utilities.swift
//  SwiftUIPageView Example
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

extension View {
    func opacityFadeMask(_ axis: Axis, inset: CGFloat = 0.2) -> some View {
        if #available(macOS 12, iOS 15, *) {
            return mask {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: max(inset, 0.0)),
                        .init(color: .black, location: max(1.0 - inset, 1.0)),
                        .init(color: .clear, location: 1.0)
                    ],
                    startPoint: axis == .horizontal ? .leading : .top,
                    endPoint: axis == .horizontal ? .trailing : .bottom
                )
            }
        } else {
            return self
        }
    }
}
