# WKWebView-Printing-Puzzle

# How To Print Using WKWebView on macOS?

## Description

How does one print using WKWebView on macOS *without* using the legacy WebView as a workaround?

I am currently using the Legacy WebView as a workaround. However, I would rather use WKWebView.

A projects `macOSLegacyWebViewPrintSnippet` and `macOSWKWebViewPrintSnippet` in the [https://github.com/marc-medley/WKWebView-Printing-Puzzle](https://github.com/marc-medley/WKWebView-Printing-Puzzle) repository, show that what works for the legacy `WebView` does not work for then newer `WKWebView`.

The supporting Apple documentation can be found at [Setting Up a Web View (Legacy)](https://developer.apple.com/documentation/webkit/setting_up_a_web_view_legacy) and [WKWebView Overview](https://developer.apple.com/documentation/webkit/wkwebview).

## Configuration

macOS 10.12.5, 10.12.6  
Xcode 8.3.3, 9.2 using Base SDK: macOS 10.12, deployment target: macOS 10.12  
Swift 4

## Steps to Reproduce

1. In Xcode 9, create a new Swift macOS project.

2. Place the following code in "ViewController.swift". Note that this code is based on the iOS example provided in https://developer.apple.com/documentation/webkit/wkwebview

    ``` swift
    import Cocoa
    import WebKit
    
    class ViewController: NSViewController {
        
        var webView: WKWebView!
        
        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            let frame = CGRect(x: 0, y: 0, width: 612, height: 792)
            webView = WKWebView(frame: frame, configuration: webConfiguration)
            view = webView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            let myURL = URL(string: "https://www.apple.com")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
        
        override var representedObject: Any? {
            didSet {
                // Update the view, if already loaded.
            }
        }
        
    }
    
    ```

3. Build & run

4. Select File menu > Print... 

    > Observe that both the preview and resulting printout are blank. 

## Related

* [OpenRadar/23649229: No Method of Printing WKWebView ](http://www.openradar.me/23649229) … duplicate of 36557179