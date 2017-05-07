//
//  RellumTextField.swift
//  Rellum
//
//  Created by Joseph Blau on 5/6/17.
//  Copyright © 2017 Design Utilities. All rights reserved.
//

import Cocoa

protocol RellumTextFieldDelegate {
    func showMenu()
}

class RellumTextField: NSTextField {

    var rellumDelegate: RellumTextFieldDelegate?
    
    required init() {
        super.init(frame: NSZeroRect)
        
        alignment = .center
        font = .menuFont(ofSize: 16)
        stringValue = "-"
        backgroundColor = .white
        textColor = .black
        isBordered = false
        isSelectable = false
        isEditable = false
        
        wantsLayer = true
        layer?.cornerRadius = 2.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func mouseDown(with event: NSEvent) {
        rellumDelegate?.showMenu()
    }
    
    func setWhite(isWhite: Bool) {
        let isDark = NSAppearance.current().name.hasPrefix("NSAppearanceNameVibrantDark")
        let whiteBGColor: NSColor? = isDark ? .clear : NSColor(deviceWhite: 0.3, alpha: 1.0)
        
        (backgroundColor, textColor, stringValue) = isWhite ?
            (whiteBGColor, .white, NSLocalizedString("white", comment: "white")) :
            (.white, .black, NSLocalizedString("black", comment: "black"))
    }
    
}
