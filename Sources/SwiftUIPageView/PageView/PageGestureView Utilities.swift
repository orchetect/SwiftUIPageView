//  SwiftUIPageView
//  Copyright (c) Ciaran O'Brien 2022
//  MIT license, see LICENSE file for details

import SwiftUI

internal extension PageGestureView {
    /// Returns base offset for the current `axis` and `alignment`.
    func baseOffset(pagesLength: CGFloat, viewLength: CGFloat) -> CGFloat {
        switch axis {
        case .horizontal:
            switch alignment.horizontal {
            case .leading: return 0
            case .center: return (viewLength - pagesLength) / 2
            case .trailing: return (viewLength - pagesLength)
            default: fatalError("Unexpected HorizontalAlignment.")
            }
            
        case .vertical:
            switch alignment.vertical {
            case .top: return 0
            case .center: return (viewLength - pagesLength) / 2
            case .bottom: return (viewLength - pagesLength)
            default: fatalError("Unexpected VerticalAlignment.")
            }
        }
    }
}
