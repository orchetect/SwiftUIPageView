//  SwiftUIPageView
//  Copyright (c) 2023 Steffan Andrews
//  MIT license, see LICENSE file for details

import SwiftUI

extension VerticalAlignment {
    var alignment: Alignment {
        switch self {
        case .top: 
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .center
        case .firstTextBaseline:
            return .center // TODO: not implemented, just return default
        case .lastTextBaseline:
            return .center // TODO: not implemented, just return default
        default:
            return .center
        }
    }
}

extension HorizontalAlignment {
    var alignment: Alignment {
        #if os(macOS) || os(iOS)
            if #available(iOS 16.0, macOS 13.0, *) { // these are unavailable on tvOS and watchOS
                switch self {
                case .listRowSeparatorLeading:
                    return .leading // TODO: not implemented, just return default
                case .listRowSeparatorTrailing:
                    return .trailing // TODO: not implemented, just return default
                default:
                    break // fall through
                }
            }
        #endif
        
        // check older options
        switch self {
        case .leading: 
            return .leading
        case .trailing:
            return .trailing
        case .center:
            return .center
        default:
            return .center
        }
    }
}
