//
//  ContentView.swift
//  SwiftUIPageView Example
//
//  Created by Steffan Andrews on 2023-10-12.
//

import SwiftUI
import SwiftUIPageView

struct ContentView: View {
    @State var pageIndex: Int = 0
    @State var beginGestureDistance: BeginGestureDistance = .short
    @State var minGestureDistance: MinimumGestureDistance = .short
    
    var body: some View {
        VStack {
            PageView(
                .horizontal,
                alignment: .center,
                pageLength: nil,
                spacing: 10,
                beginGestureDistance: beginGestureDistance,
                minGestureDistance: minGestureDistance,
                index: $pageIndex
            ) {
                TestView(text: "1")
                TestView(text: "2")
                TestView(text: "3")
            }
            .frame(width: 350)
            .opacityFadeMask(.horizontal, inset: 0.05)
            
            HStack {
                Button("Go to Page 1") {
                    pageIndex = 0
                }
                Button("Go to Page 3") {
                    pageIndex = 2
                }
            }
            HStack {
                Picker("Begin Distance:", selection: $beginGestureDistance) {
                    ForEach(beginGestureDistanceOptions, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
                Picker("Min Distance:", selection: $minGestureDistance) {
                    ForEach(minGestureDistanceOptions, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
            }
        }
        .padding()
        .onChange(of: pageIndex) { newValue in
            print("new page index:", newValue)
        }
    }
    
    var beginGestureDistanceOptions: [BeginGestureDistance] {
        [.immediate, .short, .medium, .long, .never]
    }
    
    var minGestureDistanceOptions: [MinimumGestureDistance] {
        [.short, .medium, .long]
    }
}

struct TestView: View {
    let text: String
    var body: some View {
        ZStack {
            Color(hue: CGFloat.random(in: 0 ... 1), saturation: 1, brightness: 1)
            Text(text)
                .font(.system(size: 48))
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
