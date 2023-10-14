//
//  Utilities.swift
//  SwiftUIPageView Example
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

/// Wrapper for `GroupBox` to make it more multiplatform-adaptable.
struct PaddedGroupBox<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        GroupBox(label: Text(title)) {
            groupBoxContent
        }
    }
    
    private var groupBoxContent: some View {
        #if os(macOS)
        VStack(spacing: 20) {
            content
        }
        .padding()
        #else
        content
        #endif
    }
}

/// Multiplatform-adaptable labelled content.
struct LabelledView<Label: View, Content: View>: View {
    var label: Label
    var content: Content
    
    init(_ label: Label, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    init<S: StringProtocol>(_ label: S, @ViewBuilder content: () -> Content) where Label == Text {
        self.label = Text(label)
        self.content = content()
    }
    
    var body: some View {
        HStack {
            label
            
            #if os(iOS)
            Spacer()
            #endif
            
            content
        }
    }
}

extension View {
    /// Apply a mask that fades the view's edges along an axis.
    ///
    /// - Parameters:
    ///   - axis: Axis for gradient.
    ///   - inset: Edge inset distance as a floating-point unit interval between zero and midpoint (0.0 ... 0.5).
    ///     Out-of-bounds values will be clamped.
    func opacityFadeMask(_ axis: Axis, inset: CGFloat = 0.2) -> some View {
        // clamp from 0 to midpoint
        let clampedInset = max(min(inset, 0.5), 0.0)
        
        let gradient = LinearGradient(
            stops: [
                .init(color: .clear, location: 0.0),
                .init(color: .black, location: clampedInset),
                .init(color: .black, location: 1.0 - clampedInset),
                .init(color: .clear, location: 1.0)
            ],
            startPoint: axis == .horizontal ? .leading : .top,
            endPoint: axis == .horizontal ? .trailing : .bottom
        )
        
        // use newer API when available
        if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *) {
            return mask { gradient }
        } else {
            return mask(gradient)
        }
    }
}
