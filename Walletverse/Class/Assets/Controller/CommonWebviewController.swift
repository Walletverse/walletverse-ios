//
//  CommonWebviewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import WebKit

class CommonWebviewController: BaseViewController {
    
    var urlString : String?
    
    lazy var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "changeOrientation")
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preferences
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height), configuration: config)
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        baseNaviBar.isHidden = false
        initBaseNaviLeft()
        
        if let url = URL(string: urlString ?? "") {
            var request = NSURLRequest(url: url) as URLRequest
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            webView.load(request)
            webView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height)
            baseMainV.addSubview(webView)
        }
    }
    
}

extension CommonWebviewController: WKNavigationDelegate,WKUIDelegate {
    func webView(_: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        debugPrint("didFailProvisionalNavigation: \(navigation), error: \(error)")
    }
    
    func webView(_: WKWebView, createWebViewWith _: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures _: WKWindowFeatures) -> WKWebView? {
        return nil
    }
    
    func webView(_: WKWebView, decidePolicyFor _: WKNavigationResponse, decisionHandler: @escaping (_: WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_: WKWebView, decidePolicyFor _: WKNavigationAction, decisionHandler: @escaping (_: WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let evaluateJavaScript = String(format: "message(\"onload?lang=%@\")",LocalUtil.shareInstance.getCurrentLanguage())
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(evaluateJavaScript, completionHandler: { (result, error) in

            })
        }
    }
    
}

extension CommonWebviewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}
