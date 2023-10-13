//
//  ContentView.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import SwiftUIPageView

struct ContentView: View {
    var body: some View {
        PageViewReader { pageView in
            PageView(
                .horizontal,
                alignment: .center,
                pageLength: nil,
                spacing: 10,
                gestureMinimumDistance: .custom(0.1)
            ) {
                TestView(text: "1")
                TestView(text: "2")
                TestView(text: "3")
            }
            .frame(width: 350)
            .clipped()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    pageView.moveToLast()
                }
            }
        }
    }
}

struct TestView: View {
    let text: String
    var body: some View {
        ZStack {
            Color.blue
            Text(text)
                .font(.system(size: 48))
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
