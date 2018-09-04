//
//  NSColor+Extensions.swift
//  Rellum
//
//  Created by Joseph Blau on 5/6/17.
//  Copyright © 2017 Design Utilities. All rights reserved.
//

import Cocoa

extension NSColor {
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}
