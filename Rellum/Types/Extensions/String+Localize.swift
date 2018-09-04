//
//  String+Localize.swift
//  Rellum
//
//  Created by Joe Blau on 9/3/18.
//  Copyright © 2018 Joe Blau. All rights reserved.
//

import Cocoa

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: self)
    }
}
