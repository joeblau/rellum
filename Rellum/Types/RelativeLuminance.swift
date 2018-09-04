//
//  RelativeLuminance.swift
//  Rellum
//
//  Created by Joe Blau on 9/3/18.
//  Copyright © 2018 Joe Blau. All rights reserved.
//

import Cocoa

enum RelativeLuminance {
    case white
    case black
}

extension RelativeLuminance {
    static func of(color: NSColor) -> RelativeLuminance {
        return (0.5 >= (0.2126 * color.red +
            0.7152 * color.green +
            0.0722 * color.blue)) ? .white : .black
    }
}
