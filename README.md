# SwiftUI PageView

[![Platforms - macOS 11 | iOS 14 | watchOS 7](https://img.shields.io/badge/Platforms-macOS%2011%20|%20iOS%2014%20|%20watchOS%207%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.5-5.9](https://img.shields.io/badge/Swift-5.5–5.9-orange.svg?style=flat) [![Xcode 13-15](https://img.shields.io/badge/Xcode-13–15-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/SwiftUIPageView/blob/main/LICENSE)

SwiftUI stack views with paged scrolling.

This view approximates the behavior of `TabView` using `PageTabViewStyle` but with more nuanced customizability, and usable on macOS.

![Demo](./Resources/Demo.gif "Demo")

## `PageView`

A view that arranges its children in a line, and provides paged scrolling behaviour.

### Usage

```swift
PageView(
    .horizontal,
    alignment: .center,
    pageLength: 250,
    spacing: 12,
    beginGestureDistance: .short,
    minGestureDistance: .short,
    index: $currentIndex
) {
    // page views
}
```

### Parameters

- `_ axis`: The layout axis of this page view.
- `alignment`: The guide for aligning the pages in this page view.
- `pageLength`: The width of each page, or `nil` if you want each page to fill the width of the page view.
- `spacing`: The distance between adjacent pages, or `nil` if you want the page view to choose a default distance for each pair of pages.
- `beginGestureDistance`: Minimum swipe distance before a swipe gesture begins.
- `minGestureDistance`: Minimum swipe distance before advancing to the previous or next page. Lower values increase sensitivity.
- `index`: An `Int` binding that exposes active page
- `content`: A view builder that creates the content of this page view.

## `HPageView`

A `PageView` using the `.horizontal` axis.

```swift
HPageView(alignment: .leading, pageWidth: 250, spacing: 12) {
    // page views
}
```

## `VPageView`

A `PageView` using the `.vertical` axis.

```swift
VPageView(alignment: .top, pageHeight: 250, spacing: 12) {
    // page views
}
```

## Getting Started

- Install with [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
- Import `SwiftUIPageView` to start using.
- See the [Example](Example) project to get started.

## Advanced Usage
The `strictPageAlignment` view modifier can be used to control whether page views always use their provided alignment to position pages. Without this modifier pages will be aligned to prevent leaving empty space in the page view.

## Known Issues

- Changes to the layout `axis` of a `PageView` will cause the pages to lose any internal state, and will not be animated.
- Active paging animations in a page view may interfere with other animations when the number of pages changes.
- Nested page views are not currently supported.

## Requirements

- macOS 11.0+, iOS 14.0+, or watchOS 7.0+
- Xcode 13.0+

## Contact

Initial work by Ciaran O'Brien ([@ciaranrobrien](http://github.com/ciaranrobrien))

Further contributions by Tomáš Kafka ([@tkafka](https://github.com/tkafka))

Maintained by Steffan Andrews ([@orchetect](https://github.com/orchetect))
