//
//  WebviewExtension.swift
//  macOSWKWebViewPrintSnippet
//
//

import Foundation
import AppKit
import WebKit.WKWebView
import WebKit

extension WKWebView {

    // / Yonder extension wraps `find(…)` which returns `matchFound` Bool
    //func contains(string: String) {
    //    let config = WKFindConfiguration()
    //    config.backwards = false
    //    config.caseSensitive = false
    //    config.wraps = true
    //    self.find(string, configuration: config) { (wkFindResult: WKFindResult) in
    //        print(wkFindResult.matchFound)
    //    }
    //}
    
    /// Yonder extension
    func printWebView() {
        let info = NSPrintInfo.shared
        info.horizontalPagination = .automatic
        info.verticalPagination = .automatic
        info.isVerticallyCentered = false
        info.isHorizontallyCentered = false
        info.leftMargin = 10
        info.rightMargin = 10
        info.topMargin = 10
        info.bottomMargin = 10
        let operation: NSPrintOperation = self.printOperation(with: info)
        //operation.canSpawnSeparateThread = true
        operation.showsPrintPanel = false
        operation.showsProgressPanel = false
        operation.runModal(
            for: NSWindow(), // NSWindow
            delegate: nil,   // Any? messages go to here
            didRun: nil,     // Selector?
            contextInfo: nil // UnsafeMutableRawPointer?
        )
    }
    
    /// Yonder extension
    func saveHtmlOuter(url: URL) {
        let jsString = "document.documentElement.outerHTML.toString()"

        let wkContentWorld = WKContentWorld.defaultClient
         //let wkContentWorld = WKContentWorld.world(name: "CustomContentWorld")
         //let wkContentWorld = WKContentWorld.page
        self.evaluateJavaScript(
            jsString, // javaScript: String
            in: nil, // WKFrameInfo?
            in: wkContentWorld) {
            (result: Result<Any, Error>) -> Void in // completionHandler
            switch result {
            case .success(let any):
                guard let s = any as? String else {
                    print("ERROR: WKWebView saveHtmlOuter not String convertable")
                    return
                }
                do {
                    try s.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print("ERROR: WKWebView saveHtmlOuter \(url) \(error)")
                }
            case .failure(let error):
                print("FAIL: WKWebView saveHtmlOuter \(url) \(error)")
                break
            }
        }
    }

    /// Yonder extension
    func saveImage(url: URL) {
        // --- Image Snapshot ---
        // - platform-native image
        // - contains the specified portion of the web view
        
        //let c = WKSnapshotConfiguration()
        //c.afterScreenUpdates = true
        //c.rect = self.frame // CGRect
        //c.snapshotWidth = 640 // image points
        
        let properties: [NSBitmapImageRep.PropertyKey : Any] = [:]
        self.takeSnapshot(with: nil) { (img: NSImage?, error: Error?) in
            guard
                let image = img,
                let tiff = image.tiffRepresentation,
                let imageRep = NSBitmapImageRep(data: tiff),
                let pngData = imageRep.representation(using: .png, properties: properties)
            else {
                print("FAIL: WKWebView saveImage")
                return
            }
            do {
                try pngData.write(to: url)
                return
            } catch {
                print("ERROR: WKWebView saveImage \(url) \(error)")
            }
        }
    }

    /// Yonder extension
    func savePDF(url: URL) {
        let c = WKPDFConfiguration()
        c.rect = self.frame // CGRect
        self.createPDF(configuration: c) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data): // Data
                do {
                    try data.write(to: url, options: Data.WritingOptions.atomic)
                } catch {
                    print("ERROR: WKWebView savePDF \(url) \(error)")
                }
            case .failure(let error): // Error
                print("FAIL: WKWebView savePDF \(url) \(error)")
            }
        }
    }
    
    /// Yonder extension
    func saveWebArchive(url: URL) {
        self.createWebArchiveData { (result: Result<Data, Error>) in
            switch result {
            case .success(let data): // Data
                do {
                    try data.write(to: url, options: Data.WritingOptions.atomic)
                } catch {
                    print("ERROR: WKWebView saveWebArchive \(url) \(error)")
                }
            case .failure(let error): // Error
                print("FAIL: WKWebView saveWebArchive \(url) \(error)")
            }
        }
    }

    // MARK: Data Store
    // - manages cookies, shows site store types, deletes stores
    
    /// Yonder extension
    func saveDatastoreInfo(url: URL) {
        var s = ""
        let datastore: WKWebsiteDataStore = self.configuration.websiteDataStore
        
        // Fetch data records containing the given website data types
        var types = Set<String>()
        //types = WKWebsiteDataStore.allWebsiteDataTypes()
        types.insert("WKWebsiteDataTypeWebSQLDatabases")
        types.insert("WKWebsiteDataTypeFetchCache")
        types.insert("WKWebsiteDataTypeDiskCache")
        types.insert("WKWebsiteDataTypeOfflineWebApplicationCache")
        types.insert("WKWebsiteDataTypeServiceWorkerRegistrations")
        types.insert("WKWebsiteDataTypeMemoryCache")
        types.insert("WKWebsiteDataTypeIndexedDBDatabases")
        types.insert("WKWebsiteDataTypeLocalStorage")
        types.insert("WKWebsiteDataTypeCookies")
        types.insert("WKWebsiteDataTypeSessionStorage")
        datastore.fetchDataRecords(ofTypes: types) { (recordArray: [WKWebsiteDataRecord]) in
            for record in recordArray {
                // displayName is typically the website domain name
                s.append("DataRecord: \(record.displayName) :: \(record.dataTypes)\n")
            }
            let cookiestore: WKHTTPCookieStore = datastore.httpCookieStore
            cookiestore.getAllCookies { (httpCookieArray: [HTTPCookie]) in
                for i in 0 ..< httpCookieArray.count {
                    let cookie = httpCookieArray[i]
                    s.append("cookie[\(i)] == \(cookie)\n")
                }
                do {
                    try s.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print("ERROR: WKWebView saveDatastoreInfo \(url) \(error)")
                }
            }
        }
    }
    
}
