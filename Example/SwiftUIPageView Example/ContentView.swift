//
//  ContentView.swift
//  SwiftUIPageView Example
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
    @State var pageIndex: Int = 1
    @State var beginGestureDistance: BeginGestureDistance = .short
    @State var minGestureDistance: MinimumGestureDistance = .medium
    @State var showSinglePage: Bool = false
    
    // index view
    @State var indexViewAllowsInteraction: Bool = true
    
    // constants
    static let pageSize: CGFloat = 250
    static let pageMargin: CGFloat = 48
    static let pageBounds = pageSize + pageMargin
    static let maxPageViewWidth: CGFloat = 400
    static let internalIndexViewOffset: CGFloat = 25
    static let externalIndexViewOffset: CGFloat = 85
    
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
            pageLength: showSinglePage ? nil : Self.pageSize,
            spacing: 10,
            beginGestureDistance: beginGestureDistance,
            minGestureDistance: minGestureDistance,
            index: $pageIndex
        ) {
            ForEach(pages) { $0 }
        }
        .pageIndexView(
            edge: nil, // automatic
            position: isIndexViewExternal ? .outside : .inside,
            indexRange: pages.indices,
            allowsUserInteraction: indexViewAllowsInteraction,
            scaling: 1.0
        )
        .pageIndexViewStyle(activeColor: .primary, inactiveColor: .secondary, dotSize: 6, spacing: 8)
        .pageIndexViewCapsule()
        
        .opacityFadeMask(axis, inset: 0.05)
        .disabled(!isPageViewEnabled)
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
        
        Toggle(isOn: $isPageViewEnabled.animation()) {
            Text("Enabled")
        }
        
        PaddedGroupBox(title: "Page View") {
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
            
            Toggle(isOn: $showSinglePage.animation()) {
                Text("Show Single Page")
            }
        }
        GroupBox(label: Text("Index View")) {
            Toggle(isOn: $isIndexViewExternal.animation()) {
                Text("External")
            }
            
            Toggle(isOn: $indexViewAllowsInteraction) {
                Text("Allows Interaction")
            }
            .disabled(!isPageViewEnabled)
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
