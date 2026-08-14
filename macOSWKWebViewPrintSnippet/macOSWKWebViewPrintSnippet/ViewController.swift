//
//  ViewController.swift
//  macOSWKWebViewPrintSnippet
//
//  Copyright © 2017 Example. All rights reserved.
//

import Foundation
import AppKit
import WebKit

// see: https://developer.apple.com/documentation/webkit/wkwebview

class ViewController: NSViewController {
    
    var _sidecarUrl: URL!
    var _webview: WKWebView!
    
    override func loadView() {
        _sidecarUrl = Bundle.main.bundleURL.deletingLastPathComponent()
        print(_sidecarUrl.absoluteString)
        let webviewConfig = setConfiguration()
        
        let frame = CGRect(x: 0, y: 0, width: 850, height: 1100)
        _webview = WKWebView(frame: frame, configuration: webviewConfig)
        
        // -- manage or restrict web content navigation in your
        // -- track the progress of navigation requests
        // -- handle authentication challenges for any new content.
        _webview.navigationDelegate = self // WKNavigationDelegate
        
        // -- integrate custom user interface elements into webview interactions
        _webview.uiDelegate = self // WKUIDelegate
        
        self.view = _webview
    }
    
    private func setConfiguration() -> WKWebViewConfiguration {
        let c = WKWebViewConfiguration()
        c.preferences = setPreferences()
        //
        c.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        // --- https://www.whatsmybrowser.org/ User Agent String ---
        // Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko)
        c.applicationNameForUserAgent = "Firefox/89.0" // appends App Name to User Agent String
        
        // --- WKUserContentController ---
        // - Inject JavaScript code
        // - Custom content filters ... at domain boundaries
        //let contentController = WKUserContentController()
        //c.userContentController = contentController
        
        // true: render when fully loaded
        c.suppressesIncrementalRendering = true
        
        // ----- WKDataDetectorTypes (only iOS and Catalyst)
        //let dataDetectors: WKDataDetectorTypes = []
        //c.dataDetectorTypes =
        
        // ----- WKURLSchemeHandler ... Custom URL Scheme
        
        // ----- Media -----
        c.allowsAirPlayForMediaPlayback = false
        // c.allowsInlineMediaPlayback           // iOS/Catalyst only. default: iPhone false, iPad true
        // c.allowsPictureInPictureMediaPlayback // iOS/Catalyst only. default: true
        
        return c
    }
    
    private func setPreferences() -> WKPreferences {
        let p = WKPreferences()
        p.isFraudulentWebsiteWarningEnabled = true // default: macOS true
        // default: iOS false, mac true
        p.javaScriptCanOpenWindowsAutomatically = false
        p.minimumFontSize = 0 // default: 0 points
        // tabbing includes links
        p.tabFocusesLinks = false // default: macOS false
        // textInteractionEnabled description not
        p.isTextInteractionEnabled = true // default: macOS true
        return p
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ----- Do any additional setup after loading the view. -----
        loadUrl()
    }
    
    func loadUrl() {
        //let myURL = URL(string: "https://www.example.com")!
        //let myURL = URL(string: "https://nutritionfacts.org/topics/water/")!
        //let myURL = URL(string: "https://nutritionfacts.org/?s=%22water%22")!
        let myURL = URL(string: "https://nutritionfacts.org/?s=%22fried%22+%22beans%22")!
        //let myURL = URL(string: "https://www.whatsmybrowser.org/")!
        //let myURL = URL(string: "http://plzfixit.com/")!
        let myRequest = URLRequest(
            url: myURL,
            cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: TimeInterval(15.0) // seconds
        )
        
        _webview.load(myRequest)
    }
    
    // MARK: -- Print
    
    func printWebView() {
        _webview.printWebView()
    }
    
    private func printWebView(_ webview: WKWebView) {
        webview.printWebView()
    }
    
    // MARK: -- Save Files
    
    private func saveDatastoreInfo() {
        let url = _sidecarUrl
            .appendingPathComponent("\(Date().datestampyyyyMMddHHmmss)_datastoreinfo")
            .appendingPathExtension("txt")
        _webview.saveDatastoreInfo(url: url)
    }
    
    private func saveHtmlOuter() {
        let url = _sidecarUrl
            .appendingPathComponent("\(Date().datestampyyyyMMddHHmmss)_html_outer")
            .appendingPathExtension("html")
        _webview.saveHtmlOuter(url: url)
    }
    
    private func saveImage() {
        let url = _sidecarUrl
            .appendingPathComponent("\(Date().datestampyyyyMMddHHmmss)_image")
            .appendingPathExtension("png")
        _webview.saveImage(url: url)
    }
    
    private func savePDF() {
        let url = _sidecarUrl
            .appendingPathComponent("\(Date().datestampyyyyMMddHHmmss)")
            .appendingPathExtension("pdf")
        _webview.savePDF(url: url)
    }
    
    private func saveWebArchive() {
        let url = _sidecarUrl
            .appendingPathComponent("\(Date().datestampyyyyMMddHHmmss)")
            .appendingPathExtension("webarchive")
        _webview.saveWebArchive(url: url)
    }
    
    // UIView 
    // func viewPrintFormatter() -> UIViewPrintFormatter
    // https://developer.apple.com/documentation/uikit/uiview/1621835-viewprintformatter
    // func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter)
    // https://developer.apple.com/documentation/uikit/uiview/1621844-draw
    //
    // https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010156
    //
    // https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GeneratingPDF/GeneratingPDF.html#//apple_ref/doc/uid/TP40010156-CH10-SW1
    
}

// MARK: -- WKNavigationDelegate

extension ViewController: WKNavigationDelegate {
    
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationResponse: WKNavigationResponse,
//                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("•• WKNavigationDelegate decidePolicyFor WKNavigationResponse")
//        if let response = navigationResponse.response as? HTTPURLResponse {
//            print("  statusCode == \(response.statusCode)")
//            decisionHandler(.allow)
//        }
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("•• WKNavigationDelegate decidePolicyFor WKNavigationResponse")
        if let response = navigationResponse.response as? HTTPURLResponse {
            let _ = response.allHeaderFields // headers
            //do something with headers
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("•• WKNavigationDelegate decidePolicyFor WKNavigationAction")
        decisionHandler(WKNavigationActionPolicy.allow, preferences)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("•• WKNavigationDelegate didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("•• WKNavigationDelegate didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("•• WKNavigationDelegate didFailProvisionalNavigation \(error)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("•• WKNavigationDelegate didCommit")
    }
    
    // Invoked when a main frame navigation completes.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("•• WKNavigationDelegate didFinish")
        print("   estimatedProgress == \(webView.estimatedProgress)")
        print("           isLoading == \(webView.isLoading)")
        print("           mediaType == \(webView.mediaType ?? "nil")")
        
        //printWebView(webView)
        saveDatastoreInfo()
        savePDF()
        saveHtmlOuter()
        saveImage()
        saveWebArchive()
        
        // --- Media Control ---
        //webView.closeAllMediaPresentations()
        //webView.pauseAllMediaPlayback(<#T##completionHandler: (() -> Void)?##(() -> Void)?##() -> Void#>)
        //webView.requestMediaPlaybackState(<#T##completionHandler: (WKMediaPlaybackState) -> Void##(WKMediaPlaybackState) -> Void#>)
        //webView.resumeAllMediaPlayback(<#T##completionHandler: (() -> Void)?##(() -> Void)?##() -> Void#>)
        //webView.suspendAllMediaPlayback(<#T##completionHandler: (() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("•• WKNavigationDelegate didFail \(error)")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("•• WKNavigationDelegate content process did terminate")
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        print("•• WKNavigationDelegate navigationAction didBecome")
    }
    
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        print("•• WKNavigationDelegate navigationResponse didBecome")
    }
}

// MARK: -- WKUIDelegate

extension ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("•• WKUIDelegate createWebViewWith")
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("•• WKUIDelegate did close")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("•• WKUIDelegate runJavaScriptAlertPanelWithMessage")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("•• WKUIDelegate runJavaScriptConfirmPanelWithMessage")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("•• WKUIDelegate runJavaScriptTextInputPanelWithPrompt")
    }
    
    func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        print("•• WKUIDelegate runOpenPanelWith")
    }
    
}
