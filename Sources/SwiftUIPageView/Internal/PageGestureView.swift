//  SwiftUIPageView
//  Copyright (c) 2022 Ciaran O'Brien, Tomáš Kafka
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

#if !os(tvOS)

import SwiftUI

internal struct PageGestureView<Content: View>: View {
    @Environment(\.isPageViewMarginsEnabled) private var isPageViewMarginsEnabled
    @Environment(\.isPageViewInteractiveScrollingAllowed) private var isPageViewInteractiveScrollingAllowed
    @GestureState private var isDragging = false
    @StateObject private var animationState = AnimationState()
    @StateObject private var pageState = PageState()
    
    var alignment: Alignment
    var axis: Axis
    var baseOffset: CGFloat
    var content: () -> Content
    var pageLength: CGFloat
    var spacing: CGFloat
    var beginGestureDistance: BeginGestureDistance
    var minGestureDistance: MinimumGestureDistance
    var viewLength: CGFloat
    @Binding var selection: Int // page index
    
    var body: some View {
        PageLayoutView(
            alignment: alignment,
            animationState: animationState,
            axis: axis,
            content: content,
            pageLength: pageLength,
            pageState: pageState,
            spacing: spacing,
            viewLength: viewLength
        )
        .modifier(DragAnimator(computedOffset: computedOffset, pageState: pageState))
        .offset(offset)
        .contentShape(Rectangle())
        .clipped()
        .highPriorityGesture(isPageViewInteractiveScrollingAllowed ? scrollGesture : noOpGesture)
        .onChange(of: isCancelled, perform: onDragCancelled)
        .onChange(of: selection) { onIndexChanged(newIndex: $0, animate: true) }
        .onAppear { onIndexChanged(newIndex: selection, animate: false) } // set initial index
    }
    
    private var computedOffset: CGFloat {
        let lower = offsetRange.lowerBound
        let upper = offsetRange.upperBound
        
        let computed = min(max(indexToOffset(pageState.index), lower), upper)
            + indexToOffset(pageState.indexOffset)
        
        if computed > upper {
            return (computed - upper)
                .rubberBand(viewLength: viewLength) + upper
        } else if computed < lower {
            return (computed - lower)
                .rubberBand(viewLength: viewLength) + lower
        } else {
            return computed
        }
    }
    
    private var scrollGesture: AnyGesture<DragGesture.Value> {
        let beginDistance: CGFloat
        
        switch pageState.dragState {
        case .dragging, .nearlyEnded, .ended: beginDistance = beginGestureDistance.value
        case .ending: beginDistance = 0
        }
        
        let gesture = DragGesture(minimumDistance: beginDistance)
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
            .updating($isDragging) { _, s, _ in s = true }
        
        return AnyGesture(gesture)
    }
    
    private var noOpGesture: AnyGesture<DragGesture.Value> {
        return AnyGesture(DragGesture(minimumDistance: 99999))
    }
    
    private var indexRange: (lowerBound: CGFloat, upperBound: CGFloat) {
        (offsetToIndex(offsetRange.upperBound), offsetToIndex(offsetRange.lowerBound))
    }
    
    private var isCancelled: Bool {
        switch pageState.dragState {
        case .dragging: return !isDragging
        case .ending, .nearlyEnded, .ended: return false
        }
    }
    
    private var offset: CGSize {
        switch axis {
        case .horizontal: return CGSize(width: baseOffset + computedOffset, height: 0)
        case .vertical: return CGSize(width: 0, height: baseOffset + computedOffset)
        }
    }
    
    /// Furthest (first and last) page offsets
    /// Absolute in relation to page size and view size, and not page index.
    private var offsetRange: (lowerBound: CGFloat, upperBound: CGFloat) {
        guard pageState.viewCount > 1
        else { return (0, 0) }
        
        var lowerBound = -(CGFloat(pageState.viewCount - 1) * (pageLength + spacing))
        var upperBound: CGFloat = 0
        
        if !isPageViewMarginsEnabled {
            lowerBound += (viewLength - pageLength) - baseOffset
            upperBound = -baseOffset
            
            let margin: CGFloat = baseOffset(pagesLength: pagesLength, viewLength: viewLength)
            if lowerBound > upperBound {
                lowerBound = -baseOffset + margin
                upperBound = -baseOffset + margin
            }
        }
        
        return (lowerBound, upperBound)
    }
    
    private func indexToOffset(_ index: CGFloat) -> CGFloat {
        -index * (pageLength + spacing)
    }
    
    private func offsetToIndex(_ offset: CGFloat) -> CGFloat {
        -offset / (pageLength + spacing)
    }
	
    private func intFromIndex(_ index: CGFloat) -> Int {
        if index == .infinity {
            return pageState.viewCount - 1
        } else if index == -.infinity {
            return 0
        } else if index.isNaN {
            return 0
        } else {
            return Int(round(index))
        }
    }

    /// Returns length of all pages including spacing.
    private var pagesLength: CGFloat {
        CGFloat(pageState.viewCount) * (pageLength + spacing)
    }
    
    private func onDragChanged(value: DragGesture.Value) {
        if let initialIndex = pageState.initialIndex {
            onDragUpdated(value: value, initialIndex: initialIndex)
        } else {
            onDragStarted(value: value)
        }
    }
    
    private func onDragStarted(value: DragGesture.Value) {
        let additionalOffset: CGFloat
        switch axis {
        case .horizontal: additionalOffset = value.translation.width
        case .vertical: additionalOffset = value.translation.height
        }
        
        var offset: CGFloat
        
        switch pageState.dragState {
        case .dragging, .nearlyEnded, .ended: offset = computedOffset
        case .ending: offset = pageState.offset
        }
        
        let initialOffset: CGFloat
        if offset < offsetRange.lowerBound {
            initialOffset = additionalOffset - (offset - offsetRange.lowerBound).invertRubberBand(viewLength: viewLength)
            offset = offsetRange.lowerBound
        } else if offset > offsetRange.upperBound {
            initialOffset = additionalOffset - (offset - offsetRange.upperBound).invertRubberBand(viewLength: viewLength)
            offset = offsetRange.upperBound
        } else {
            initialOffset = additionalOffset
        }
        
        animationState.dragAnimation = .dragStarted
        pageState.dragState = .dragging
        pageState.initialIndex = offsetToIndex(initialOffset)
        
        withAnimation(animationState.dragAnimation) {
            pageState.index = offsetToIndex(offset)
            pageState.indexOffset = offsetToIndex(additionalOffset - initialOffset)
        }
    }
    
    private func onDragUpdated(value: DragGesture.Value, initialIndex: CGFloat) {
        let additionalOffset: CGFloat
        
        switch axis {
        case .horizontal: additionalOffset = value.translation.width
        case .vertical: additionalOffset = value.translation.height
        }
        
        pageState.indexOffset = offsetToIndex(additionalOffset) - initialIndex
    }
    
    private func onDragCancelled(isCancelled: Bool) {
        guard isCancelled else { return }
        
        DispatchQueue.main.async {
            guard self.isCancelled else { return }
            
            let index = min(max(pageState.index, indexRange.lowerBound), indexRange.upperBound)
            var newIndex = round(index)
            
            if newIndex <= indexRange.lowerBound {
                newIndex = -.infinity
            } else if newIndex >= indexRange.upperBound {
                newIndex = .infinity
            }
            
            let distance = min(max(indexToOffset(newIndex), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
            
            animationState.dragAnimation = .dragEnded(distance: distance, velocity: 0, viewLength: viewLength)
            pageState.dragState = distance == 0 ? .ended : .ending
            pageState.initialIndex = nil
            
            withAnimation(animationState.dragAnimation) {
                pageState.index = newIndex
                pageState.indexOffset = 0
                self.selection = intFromIndex(newIndex)
            }
        }
    }
    
    private func onDragEnded(value: DragGesture.Value) {
        let index = min(max(pageState.index + pageState.indexOffset, indexRange.lowerBound), indexRange.upperBound)
        var newIndex: CGFloat
        let velocity: CGFloat
        
        switch axis {
        case .horizontal: velocity = value.velocity.width
        case .vertical: velocity = value.velocity.height
        }
        
        var minDistancePts = minGestureDistance.value
        if minDistancePts.isZero { // avoid division by zero
            minDistancePts = 1
        }
        let minDistanceFloat: CGFloat = minDistancePts / pageLength
        
        if (-1 ... 1).contains(pageState.indexOffset) { // less than one page travel distance
            if pageState.indexOffset > minDistanceFloat {
                newIndex = floor(index + 1)
            } else if pageState.indexOffset < -minDistanceFloat {
                newIndex = ceil(index - 1)
            } else {
                newIndex = round(index)
            }
        } else if velocity <= -.velocityThreshold {
            newIndex = floor(index + 1)
        } else if velocity >= .velocityThreshold {
            newIndex = ceil(index - 1)
        } else {
            newIndex = round(index)
        }
        
        if newIndex <= indexRange.lowerBound {
            newIndex = -.infinity
        } else if newIndex >= indexRange.upperBound {
            newIndex = .infinity
        }
        
        let distance = min(max(indexToOffset(newIndex), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
        
        animationState.dragAnimation = .dragEnded(distance: distance, velocity: velocity, viewLength: viewLength)
        pageState.dragState = distance == 0 ? .ended : .ending
        pageState.initialIndex = nil
        
        withAnimation(animationState.dragAnimation) {
            pageState.index = newIndex
            pageState.indexOffset = 0
            self.selection = intFromIndex(newIndex)
        }
    }
    
    private func onIndexChanged(newIndex: Int, animate: Bool) {
        if animate {
            withAnimation {
                pageTo(index: CGFloat(newIndex))
            }
        } else {
            pageTo(index: CGFloat(newIndex))
        }
    }
    
    private func pageTo(index: CGFloat) {
        let newIndex: CGFloat
        
        if index <= indexRange.lowerBound {
            newIndex = -.infinity
        } else if index >= indexRange.upperBound {
            newIndex = .infinity
        } else {
            newIndex = index
        }
        
        let distance = min(max(indexToOffset(newIndex), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
        
        pageState.dragState = distance == 0 ? .ended : .ending
        pageState.index = newIndex
        pageState.indexOffset = 0
        self.selection = intFromIndex(newIndex)
    }
}

#endif
