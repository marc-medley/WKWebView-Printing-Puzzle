//
//  ViewController.swift
//  macOSWKWebViewPrintSnippet
//
//  Copyright © 2017 Example. All rights reserved.
//

import Cocoa
import WebKit

// see: https://developer.apple.com/documentation/webkit/wkwebview

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: 612, height: 792)
        webView = WKWebView(frame: frame, configuration: webConfiguration)
        //webView.navigationDelegate = self
        //webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myURL = URL(string: "https://www.example.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}


