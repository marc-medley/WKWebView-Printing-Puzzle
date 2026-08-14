# WKWebView-Printing-Puzzle

# How To Print Using WKWebView on macOS?

## Description

How does one print using WKWebView on macOS *without* using the legacy WebView as a workaround?

I am currently using the Legacy WebView as a workaround. However, I would rather use WKWebView.

A projects `macOSLegacyWebViewPrintSnippet` and `macOSWKWebViewPrintSnippet` in the [https://github.com/marc-medley/WKWebView-Printing-Puzzle](https://github.com/marc-medley/WKWebView-Printing-Puzzle) repository, show that what works for the legacy `WebView` does not work for then newer `WKWebView`.

The supporting Apple documentation can be found at [Setting Up a Web View (Legacy)](https://developer.apple.com/documentation/webkit/setting_up_a_web_view_legacy) and [WKWebView Overview](https://developer.apple.com/documentation/webkit/wkwebview).

## Configuration

* macOS 10.15.4  
* Xcode 11.4.1 deployment target: macOS 10.15  
* Apple Swift version 5.2.2 (swiftlang-1103.0.32.6 clang-1103.0.32.51)

In build settings, `CODE_SIGN_IDENTITY` needs to be changed from `-` to either `""` (Don't Code Sign) or to a specific code sign identity.

## Steps to Reproduce

1. In Xcode 11.4.1, create a new Swift macOS project.

2. Place the following code in "ViewController.swift". Note that this code is based on the iOS example provided in <https://developer.apple.com/documentation/webkit/wkwebview>

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
    
## Observation

An attempt to resolve issue with Project Settings > Target > Capabilities > App Sandbox: ON, [√] Printing did not work.

## http insecure links

_basic_

``` xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>yourdomain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

_some additional properties_

Be aware, using `NSAllowsArbitraryLoads = true` in the project's `info.plist` allows all connection to any server to be insecure.

``` xml
<key>NSAppTransportSecurity</key>
    <dict>
        <!-- NSAllowsArbitraryLoads: true may be too broad? -->
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>yourdomain.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
                <false/>
            </dict>
       </dict>
  </dict>
```

## Related

* [OpenRadar/23649229: No Method of Printing WKWebView ](http://www.openradar.me/23649229) … duplicate of 36557179. Also reported as 33343418.
