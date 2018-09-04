//
//  AppDelegate.swift
//  Rellum
//
//  Created by Joseph Blau on 5/6/17.
//  Copyright © 2017 Design Utilities. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    fileprivate var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    private let rellumTextField = RellumTextField()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow().collectionBehavior = .canJoinAllSpaces

        statusItem.menu = NSMenu()
        statusItem.view = NSView()
        statusItem.highlightMode = false

        rellumTextField.rellumDelegate = self

        buildMenu()
        configureViews()
        subscribeToAllEvents()
    }

    // MARK: - Selectors
    
    func quit() {
        NSApp.terminate(self)
    }

    // MARK: - Private

    private func buildMenu() {
        guard let statusItemMenu = statusItem.menu else { return }
        statusItemMenu.addItem(withTitle: NSLocalizedString("quit", comment: "quit"), action: #selector(quit), keyEquivalent: "")
    }

    private func configureViews() {
        guard let statusItemView = statusItem.view else { return }
        statusItemView.translatesAutoresizingMaskIntoConstraints = false
        statusItemView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        statusItemView.heightAnchor.constraint(equalToConstant: NSStatusBar.system().thickness).isActive = true

        statusItemView.addSubview(rellumTextField)
        rellumTextField.topAnchor.constraint(equalTo: statusItemView.topAnchor, constant: 2).isActive = true
        rellumTextField.bottomAnchor.constraint(equalTo: statusItemView.bottomAnchor, constant: -2).isActive = true
        rellumTextField.leftAnchor.constraint(equalTo: statusItemView.leftAnchor).isActive = true
        rellumTextField.rightAnchor.constraint(equalTo: statusItemView.rightAnchor).isActive = true
    }

    private func subscribeToAllEvents() {
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (mouseEvent) in

            let pixel = CGRect(x: mouseEvent.locationInWindow.x,
                               y: mouseEvent.locationInWindow.y,
                               width: 1,
                               height: 1)
            guard let pixelImage = CGWindowListCreateImage(pixel, .optionOnScreenOnly, 0, .bestResolution),
                let pixelColor = NSBitmapImageRep(cgImage: pixelImage).colorAt(x: 0, y: 0)  else {
                    return
            }
            let isWhite = 0.5 >= (0.2126 * pixelColor.components.red + 0.7152 * pixelColor.components.green + 0.0722 * pixelColor.components.blue)

            self.rellumTextField.setWhite(isWhite: isWhite)
        }
    }
}

extension AppDelegate: RellumTextFieldDelegate {
    func showMenu() {
        guard let statusItemMenu = statusItem.menu else { return }
        statusItem.popUpMenu(statusItemMenu);
    }
}

autoreleasepool { () -> () in
    let app = NSApplication.shared()
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
