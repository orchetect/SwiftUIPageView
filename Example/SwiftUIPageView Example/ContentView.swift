//
//  ContentView.swift
//  SwiftUIPageView Example
//
//  Created by Steffan Andrews on 2023-10-12.
//

import SwiftUI
import SwiftUIPageView

struct ContentView: View {
    @State var axis: Axis = .horizontal
    @State var isIndexViewExternal: Bool = false
    
    @State var isPageViewEnabled: Bool = true
    @State var pageIndex: Int = 1
    @State var beginGestureDistance: BeginGestureDistance = .short
    @State var minGestureDistance: MinimumGestureDistance = .medium
    
    @State var isIndexViewEnabled: Bool = true
    @State var indexViewAllowsInteraction: Bool = true
    @State var indexViewCapsuleScaling: CGFloat = 1.0
    
    static let pageSize: CGFloat = 250
    static let pageMargin: CGFloat = 35
    static let pageBounds = pageSize + pageMargin
    static let maxPageViewWidth: CGFloat = 400
    static let internalIndexViewOffset: CGFloat = 25
    static let externalIndexViewOffset: CGFloat = 85
    
    var body: some View {
        VStack {
            ZStack {
                pageView
                adaptingIndexView
            }
            Spacer().frame(height: 40)
            optionsView
        }
        .padding()
        .onChange(of: pageIndex) { newValue in
            print("New page index:", newValue)
        }
    }
    
    @ViewBuilder 
    private var pageView: some View {
        PageView(
            axis,
            alignment: .center,
            pageLength: nil,
            spacing: 10,
            beginGestureDistance: beginGestureDistance,
            minGestureDistance: minGestureDistance,
            index: $pageIndex
        ) {
            ForEach(pages) { $0 }
        }
        .frame(maxWidth: axis == .horizontal ? Self.maxPageViewWidth : Self.pageBounds)
        .frame(height: Self.pageBounds)
        .opacityFadeMask(axis, inset: 0.05)
        .disabled(!isPageViewEnabled)
    }
    
    /// Adapt index view to selected axis.
    @ViewBuilder
    private var adaptingIndexView: some View {
        let offset = isIndexViewExternal ? Self.externalIndexViewOffset : -Self.internalIndexViewOffset
        
        switch axis {
        case .horizontal:
            VStack {
                Spacer()
                indexView
            }
            .frame(width: Self.pageSize, height: Self.pageSize + offset)
        case .vertical:
            HStack {
                indexView
                Spacer()
            }
            .frame(width: Self.pageSize + offset, height: Self.pageSize)
        }
    }
    
    @ViewBuilder
    private var indexView: some View {
        PageIndexView(
            axis,
            indexRange: pages.indices,
            index: $pageIndex,
            allowsUserInteraction: indexViewAllowsInteraction
        )
        .pageIndexViewStyle(
            activeColor: .primary,
            inactiveColor: .secondary,
            dotSize: 6,
            spacing: 8
        )
        .pageIndexViewCapsule(.secondary.opacity(0.4), scaling: 1.5)
        .disabled(!isIndexViewEnabled)
    }
    
    @ViewBuilder
    private var optionsView: some View {
        LabelledView("Axis") {
            Picker("", selection: $axis /* .animation() */) {
                ForEach(Axis.allCases, id: \.self) { axis in
                    Text(String(describing: axis.description)).tag(axis)
                }
            }
            .labelsHidden()
            .fixedSize()
        }
        
        PaddedGroupBox(title: "Page View") {
            Toggle(isOn: $isPageViewEnabled.animation()) {
                Text("Enabled")
            }
            
            HStack(spacing: 20) {
                Button("Go to Page 1") {
                    pageIndex = 0
                }
                
                Button("Go to Page 3") {
                    pageIndex = 2
                }
            }
            
            LabelledView("Begin Swipe Distance") {
                Picker("", selection: $beginGestureDistance) {
                    ForEach(beginGestureDistanceOptions, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }
            .disabled(!isPageViewEnabled)
            
            LabelledView("Min Swipe Distance") {
                Picker("", selection: $minGestureDistance) {
                    ForEach(minGestureDistanceOptions, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }
            .disabled(!isPageViewEnabled)
        }
        GroupBox(label: Text("Index View")) {
            Toggle(isOn: $isIndexViewEnabled.animation()) {
                Text("Enabled")
            }
            
            Toggle(isOn: $isIndexViewExternal.animation()) {
                Text("External")
            }
            
            Toggle(isOn: $indexViewAllowsInteraction) {
                Text("Allows Interaction")
            }
            .disabled(!isIndexViewEnabled)
        }
    }
    
    // MARK: Data model
    
    var pages = [
        TestView(text: "1", size: pageSize),
        TestView(text: "2", size: pageSize),
        TestView(text: "3", size: pageSize)
    ]
    
    var beginGestureDistanceOptions: [BeginGestureDistance] {
        [.immediate, .short, .medium, .long, .never]
    }
    
    var minGestureDistanceOptions: [MinimumGestureDistance] {
        [.short, .medium, .long]
    }
}

struct TestView: View, Identifiable {
    let id = UUID()
    let text: String
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Color(hue: CGFloat.random(in: 0 ... 1), saturation: 1, brightness: 1)
            Text(text)
                .foregroundColor(.primary)
                .font(.system(size: 48))
        }
        .frame(width: size, height: size)
        .shadow(radius: 10)
    }
}

#Preview {
    ContentView()
}
