//
//  AppDelegate.swift
//  macOSWKWebViewPrintSnippet
//
//  Copyright © 2017 Example. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func doPrintMenuItem(_ sender: Any) {
        guard
            let window = NSApplication.shared.mainWindow,
            //let windowVC = window.windowController,
            let contentVC = window.contentViewController,
            let vc = contentVC as? ViewController
        else {
            print("doPrintMenuItem view controllers not found")
            return
        }
                
        vc.printWebView()
    }
    
}

