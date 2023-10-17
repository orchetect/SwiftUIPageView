//
//  Utilities.swift
//  SwiftUIPageView Demo
//
//  Created by Steffan Andrews on 2023-10-13.
//

import SwiftUI

/// Wrapper for `GroupBox` to make it more multiplatform-adaptable.
struct PaddedGroupBox<Content: View>: View {
    var title: String
    var content: Content
    var spacing: CGFloat
    
    init(title: String, spacing: CGFloat = 10, @ViewBuilder content: () -> Content) {
        self.title = title
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        GroupBox(label: Text(title)) {
            groupBoxContent
        }
    }
    
    private var groupBoxContent: some View {
        #if os(macOS)
        VStack(spacing: spacing) {
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
