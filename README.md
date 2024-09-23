# SwiftUI PageView

[![Platforms - macOS 11 | iOS 14 | watchOS 7](https://img.shields.io/badge/Platforms-macOS%2011%20|%20iOS%2014%20|%20watchOS%207%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.5-5.9](https://img.shields.io/badge/Swift-5.5–5.9-orange.svg?style=flat) [![Xcode 13-15](https://img.shields.io/badge/Xcode-13–15-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/SwiftUIPageView/blob/main/LICENSE)

SwiftUI stack views with paged scrolling in a horizontal or vertical axis, and an optional index display.

This view approximates the behavior of [`TabView`](https://developer.apple.com/documentation/swiftui/tabview) using [`PageTabViewStyle`](https://developer.apple.com/documentation/swiftui/pagetabviewstyle) but with more nuanced customizability, and support for both macOS and iOS.

![](https://github.com/orchetect/SwiftUIPageView/assets/11605557/28391079-001a-4b54-88ca-9d43698ab013)

## `PageView`

A view that arranges its children in a line, and provides paged scrolling behaviour.

```swift
PageView(
    .horizontal,
    alignment: .center,
    pageLength: 250,
    spacing: 12,
    beginGestureDistance: .short,
    minGestureDistance: .short,
    fadeScrollEdgesInset: 0.1,
    selection: $currentIndex
) {
    // page views
}
```

- `_ axis`: The layout axis of this page view.
- `alignment`: The guide for aligning the pages in this page view.
- `pageLength`: The width of each page, or `nil` if you want each page to fill the width of the page view.
- `spacing`: The distance between adjacent pages, or `nil` if you want the page view to choose a default distance for each pair of pages.
- `beginGestureDistance`: Minimum swipe distance before a swipe gesture begins.
- `minGestureDistance`: Minimum swipe distance before advancing to the previous or next page. Lower values increase sensitivity.
- `fadeScrollEdgesInset`: Apply an alpha fade on the scroll edges of the view with the given inset amount.
- `selection`: An `Int` binding that exposes active page
- `content`: A view builder that creates the content of this page view.

## `PageView` View Modifiers

### Margins

By default, margins are enabled.

When enabled, the currently selected page will always follow the `alignment` property with regards the page view's entire frame area. This means that if the page view is larger than the page size, the first and last pages will have empty area before or after them when they are the selected pages.

When disabled, the alignment property will be followed whenever possible, but otherwise the selected page will follow the alignment as close as possible without creating empty area around it.

```swift
PageView( ... )
    .pageViewMarginsEnabled(false)
```

### Index View

An optional index view may be displayed by attaching the `pageIndexView` view modifier.

The position and user interactivity behavior may be specified.

```swift
PageView( ... )
    .pageViewIndexDisplay(
        edge: nil,
        position: .inside,
        indexRange: pages.indices,
        allowsUserInteraction: true
    )
```

- `edge`: Edge to attach the index view. If `nil`, its position will be automatic based on the page view's axis.
- `position`: Position for the index view. Can be inside (overlay), external, or a custom offset.
- `indexRange`: Page index range of the ``PageView``.
- `allowsUserInteraction`: If `true`, clicking on an index dot will cause the ``PageView`` to go to that page index.

### Index View Style

Custom style attributes may optionally be applied to the index view.

If not specified, the index view will use its default style.

> [!NOTE]
> This has no effect unless the `pageViewIndexDisplay` modifier has also been applied to the `PageView`.

```swift
PageView( ... )
    .pageViewIndexDisplay( ... )
    .pageIndexViewStyle(
        activeColor: .primary,
        inactiveColor: .secondary,
        dotSize: 6,
        spacing: 8,
        scaling: 1.0
    )
```

- `activeColor`: The color for the currently active index.
- `inactiveColor`: The color for the inactive indices.
- `dotSize`: Dot size in points.
- `spacing`: Spacing between dots in points.
- `scaling`: Scaling factor.

### Index View Capsule

A capsule background may optionally be added to the index view.

> [!NOTE]
> This has no effect unless the `pageViewIndexDisplay` modifier has also been applied to the `PageView`.

```swift
PageView( ... )
    .pageViewIndexDisplay( ... )
    .pageIndexViewCapsule(/* Color */)
```

- `color`: Capsule color. If `nil`, an appropriate default color will be used.

## Getting Started

1. Add to your app project or Swift package using [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)
2. Import `SwiftUIPageView`
3. See the [Demo](Demo) project for a demonstration

## Known Issues

- Changes to the layout `axis` of a `PageView` will cause the pages to lose any internal state, and will not be animated.
- Active paging animations in a page view may interfere with other animations when the number of pages changes.
- Nested page views are not currently supported.

## Requirements

- macOS 11.0+, iOS 14.0+, or watchOS 7.0+
- Xcode 13.0+

## Authors

Initial work by Ciaran O'Brien ([@ciaranrobrien](http://github.com/ciaranrobrien))

Further contributions by Tomáš Kafka ([@tkafka](https://github.com/tkafka))

Maintained by Steffan Andrews ([@orchetect](https://github.com/orchetect))
