//
//  RellumTextField.swift
//  Rellum
//
//  Created by Joe Blau on 5/6/17.
//  Copyright © 2017 Joe Blau. All rights reserved.
//

import Cocoa

protocol RellumTextFieldDelegate: class {
    func showMenu()
}

class RellumTextField: NSTextField {

    weak var rellumDelegate: RellumTextFieldDelegate?

    required init() {
        super.init(frame: NSRect.zero)

        alignment = .center
        font = .menuFont(ofSize: 16)
        stringValue = "-"
        backgroundColor = .white
        textColor = .black
        isBordered = false
        isSelectable = false
        isEditable = false
        translatesAutoresizingMaskIntoConstraints = false

        wantsLayer = true
        layer?.cornerRadius = 2.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override func mouseDown(with event: NSEvent) {
        rellumDelegate?.showMenu()
    }

    func rellum(rellum: RelativeLuminance) {
        switch rellum {
        case .white:
            backgroundColor = rellumBackgroundColor
            textColor = .white
            stringValue = "white".localize
        case .black:
            backgroundColor = .white
            textColor = .black
            stringValue = "black".localize
        }
    }

    private var rellumBackgroundColor: NSColor {
        switch NSAppearance.isDark {
        case true: return .clear
        case false: return NSColor(deviceWhite: 0.3, alpha: 1.0)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAppearanceName(_ input: NSAppearance.Name) -> String {
	return input.rawValue
}
