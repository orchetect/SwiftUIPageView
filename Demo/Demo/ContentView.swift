//
//  ContentView.swift
//  SwiftUIPageView Demo
//
//  Created by Steffan Andrews on 2023-10-12.
//

import SwiftUI
import SwiftUIPageView

struct ContentView: View {
    // page view + index view
    @State var axis: Axis = .horizontal
    @State var isIndexViewExternal: Bool = false
    @State var isPageViewEnabled: Bool = true
    
    // page view
    @State var alignment: Alignment = .center
    @State var pageIndex: Int = 1
    @State var beginGestureDistance: BeginGestureDistance = .short
    @State var minGestureDistance: MinimumGestureDistance = .medium
    @State var showSinglePage: Bool = false
    @State var isEdgesFaded: Bool = false
    @State var isMarginsEnabled: Bool = true
    
    // index view
    @State var indexViewAllowsInteraction: Bool = true
    @State var isIndexViewLarge: Bool = false
    
    var body: some View {
        VStack {
            pageView
                .frame(height: Self.pageBounds)
            Spacer()
                .frame(height: 40)
            ScrollView {
                optionsView
                    .padding([.leading, .trailing], 5)
            }
            .frame(minHeight: Self.optionsHeight)
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
            alignment: alignment,
            pageLength: showSinglePage ? nil : Self.pageSize,
            spacing: 10,
            beginGestureDistance: beginGestureDistance,
            minGestureDistance: minGestureDistance,
            fadeScrollEdgesInset: isEdgesFaded ? 0.05 : nil,
            index: $pageIndex
        ) {
            ForEach(pages) { $0 }
        }
        .pageViewIndexDisplay(
            edge: nil, // automatic
            position: isIndexViewExternal ? .outside : .inside,
            indexRange: pages.indices,
            allowsUserInteraction: indexViewAllowsInteraction
        )
        .pageIndexViewStyle(
            activeColor: .primary,
            inactiveColor: .secondary,
            dotSize: 6,
            spacing: 8,
            scaling: isIndexViewLarge ? 1.5 : 1.0
        )
        .pageIndexViewCapsule(/* .blue */)
        .pageViewMarginsEnabled(isMarginsEnabled)
        .disabled(!isPageViewEnabled)
    }
    
    @ViewBuilder
    private var optionsView: some View {
        VStack {
            Toggle(isOn: $isPageViewEnabled.animation()) {
                Text("Enabled")
            }
            
            LabelledView("Axis") {
                Picker("", selection: $axis /* .animation() */) {
                    ForEach(Axis.allCases, id: \.self) { axis in
                        Text(axis.name).tag(axis)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }
            
            LabelledView("Alignment") {
                Picker("", selection: $alignment.animation()) {
                    ForEach(Alignment.allPageViewCases) { align in
                        Text(align.name).tag(align)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }
            
            Toggle(isOn: $isMarginsEnabled.animation()) {
                Text("Use Margins")
            }
            
            HStack(spacing: 20) {
                Button("Go to Page 1") {
                    pageIndex = 0
                }
                
                Button("Go to Page 3") {
                    pageIndex = 2
                }
            }
            
            PaddedGroupBox(title: "Page View Settings") {
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
                
                Toggle(isOn: $showSinglePage.animation()) {
                    Text("Show Single Page")
                }
                
                Toggle(isOn: $isEdgesFaded.animation()) {
                    Text("Fade Scroll Edges")
                }
            }
            
            PaddedGroupBox(title: "Index View Settings") {
                Toggle(isOn: $isIndexViewExternal.animation()) {
                    Text("External")
                }
                
                Toggle(isOn: $isIndexViewLarge.animation()) {
                    Text("Large")
                }
                
                Toggle(isOn: $indexViewAllowsInteraction) {
                    Text("Allows Interaction")
                }
                .disabled(!isPageViewEnabled)
            }
        }
    }
    
    // MARK: Data model
    
    var pages = [
        TestView(text: "1", size: pageSize),
        TestView(text: "2", size: pageSize),
        TestView(text: "3", size: pageSize),
        TestView(text: "4", size: pageSize)
    ]
    
    var beginGestureDistanceOptions: [BeginGestureDistance] {
        [.immediate, .short, .medium, .long, .never]
    }
    
    var minGestureDistanceOptions: [MinimumGestureDistance] {
        [.short, .medium, .long]
    }
}

// MARK: - Geometry

extension ContentView {
    static let pageSize: CGFloat = 250
    static let pageMargin: CGFloat = 48
    static let pageBounds = pageSize + pageMargin
    static let maxPageViewWidth: CGFloat = 400
    static let internalIndexViewOffset: CGFloat = 25
    static let externalIndexViewOffset: CGFloat = 85
    
    #if os(macOS)
    static let optionsHeight: CGFloat = 380
    #else
    static let optionsHeight: CGFloat = 200
    #endif
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
