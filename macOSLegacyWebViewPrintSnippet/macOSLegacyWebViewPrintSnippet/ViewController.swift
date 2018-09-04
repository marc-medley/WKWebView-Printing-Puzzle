//
//  ViewController.swift
//  macOSLegacyWebViewPrintSnippet
//
//  Copyright © 2017 Example. All rights reserved.
//

import Cocoa
import WebKit

// see: https://developer.apple.com/documentation/webkit/setting_up_a_web_view_legacy

class ViewController: NSViewController {
    
    var webView: WebView!
    
    override func loadView() {
        let frame = NSRect(x: 0, y: 0, width: 612, height: 792)
        webView = WebView(frame: frame)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let myURL = URL(string: "https://www.example.com")
        let myRequest = URLRequest(url: myURL!)
        webView.mainFrame.load(myRequest)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
