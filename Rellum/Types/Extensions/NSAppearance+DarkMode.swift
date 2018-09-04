//
//  NSAppearance+DarkMode.swift
//  Rellum
//
//  Created by Joe Blau on 9/3/18.
//  Copyright © 2018 Joe Blau. All rights reserved.
//

import Cocoa

extension NSAppearance {
    static var isDark: Bool {
        return NSAppearance.current
            .name
            .rawValue
            .hasPrefix("NSAppearanceNameVibrantDark")
    }
}
