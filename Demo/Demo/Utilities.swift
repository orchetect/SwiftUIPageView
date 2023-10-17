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

// MARK: - Axis

extension Axis {
    var name: String {
        switch self {
        case .horizontal: return "Horizontal"
        case .vertical: return "Vertical"
        }
    }
}

// MARK: - Alignment

extension Alignment {
    public var name: String {
        switch self {
        case Self.center: return "Center"
        case Self.leading: return "Leading"
        case Self.trailing: return "Trailing"
        case Self.top: return "Top"
        case Self.bottom: return "Bottom"
        case Self.topLeading: return "Top Leading"
        case Self.topTrailing: return "Top Trailing"
        case Self.bottomLeading: return "Bottom Leading"
        case Self.bottomTrailing: return "Bottom Trailing"
        default: return String(describing: self)
        }
    }
}

extension Alignment: Identifiable {
    public var id: String { name }
}

extension Alignment: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Alignment {
    static public var allPageViewCases = [
        Self.center,
        Self.leading,
        Self.trailing,
        Self.top,
        Self.bottom,
        
        // unsupported in SwiftUIPageView (currently)
        // Self.topLeading,
        // Self.topTrailing,
        // Self.bottomLeading,
        // Self.bottomTrailing
        
        // unsupported in SwiftUIPageView (currently)
        // Self.centerFirstTextBaseline
        // Self.centerLastTextBaseline
        // Self.leadingFirstTextBaseline
        // Self.leadingLastTextBaseline
        // Self.trailingFirstTextBaseline
        // Self.trailingLastTextBaseline
    ]
}
