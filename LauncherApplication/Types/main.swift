//
//  main.swift
//  LauncherApplication
//
//  Created by Joe Blau on 9/3/18.
//  Copyright © 2018 Joe Blau. All rights reserved.
//

import Cocoa

autoreleasepool { () -> Void in
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
