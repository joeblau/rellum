//
//  AppDelegate.swift
//  Rellum
//
//  Created by Joseph Blau on 5/6/17.
//  Copyright © 2017 Design Utilities. All rights reserved.
//

import Cocoa
import SnapKit
import RxCocoa
import RxSwift

class AppDelegate: NSObject, NSApplicationDelegate, RellumTextFieldDelegate {
    
    private var window = NSWindow()
    private var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    private let statusBarHeight = NSStatusBar.system().thickness
    private let bag = DisposeBag()
    private let rellumTextField = RellumTextField()
    private let statusItemView = NSView()
    private let ddMenu = NSMenu()
    private let timerSignal = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.collectionBehavior = .canJoinAllSpaces
        
        ddMenu.addItem(withTitle: NSLocalizedString("quit", comment: "quit"), action: #selector(quit), keyEquivalent: "")
        
        statusItem.menu = ddMenu
        statusItem.highlightMode = false
        statusItem.view = statusItemView
        
        statusItemView.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(statusBarHeight)
        }
        
        rellumTextField.rellumDelegate = self
        statusItemView.addSubview(rellumTextField)
        
        rellumTextField.snp.makeConstraints { (make) in
            make.top.equalTo(statusItemView.snp.top).offset(2)
            make.left.equalTo(statusItemView.snp.left)
            make.right.equalTo(statusItemView.snp.right)
            make.height.equalTo(statusItemView.snp.height).offset(-4)
        }
        
        timerSignal
            .map { _ -> NSPoint in
                let mouseLocation = NSEvent.mouseLocation()
                let principalScreen = NSScreen.screens()?.first
                return NSPoint(x: mouseLocation.x, y: principalScreen!.frame.size.height - mouseLocation.y)
            }
            .subscribe { (mouseLocation) in
                guard let x = mouseLocation.element?.x,
                    let y = mouseLocation.element?.y else {
                        return
                }
                
                guard let imageRef = CGWindowListCreateImage(CGRect(x: x, y: y, width: 1, height: 1), .optionOnScreenOnly, 0, .bestResolution) else {
                    return
                }
                let bitmap = NSBitmapImageRep(cgImage: imageRef)
                guard let pixelColor = bitmap.colorAt(x: 0, y: 0) else {
                    return
                }
                let isWhite = 0.5 >= (0.2126 * pixelColor.components.red + 0.7152 * pixelColor.components.green + 0.0722 * pixelColor.components.blue)
                
                self.rellumTextField.setWhite(isWhite: isWhite)
            }
            .addDisposableTo(bag)
    }
    
    // MARK: - RelumLabelDelegate
    
    func showMenu() {
        statusItem.popUpMenu(ddMenu);
    }
    
    // MARK: - Selectors
    
    func quit() {
        NSApp.terminate(self)
    }
}

autoreleasepool { () -> () in
    let app = NSApplication.shared()
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
