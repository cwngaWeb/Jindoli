//
//  CWWebViewController.swift
//  webViewControllerLib
//
//  Created by Anson on 2018/7/28.
//  Copyright © 2018 Calophasis. All rights reserved.
//

import UIKit
import WebKit
public class CWWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    private var webview = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView(self.webview)
    }

    public func setUrl(url: URL) {
        let request = URLRequest(url: url)
        self.webview.load(request)
    }

    func setupWebView(_ inputWebView:WKWebView) {
        inputWebView.frame = self.view.bounds
        self.view.addSubview(inputWebView)
        inputWebView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        inputWebView.uiDelegate = self
        inputWebView.navigationDelegate = self
    }

    func addCloseButton(view: UIView) {
        let marginLength = CGFloat(20)
        let sizeLength = CGFloat(40)

        let closeButton = UIButton.init(frame: CGRect(x: view.frame.width -  marginLength - sizeLength,
                                                      y: marginLength,
                                                      width: sizeLength, height: sizeLength))
        closeButton.setTitle("X", for: UIControlState.normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(closeButton)
        closeButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        closeButton.addTarget(self, action: #selector(wkViewRemoveFromSuperView(button:)), for: UIControlEvents.touchUpInside)
    }

    @objc func wkViewRemoveFromSuperView(button: UIButton) {
        button.superview?.removeFromSuperview()
    }

    //MARK :- <WKNavigationDelegate>

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }


    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alertVC = UIAlertController(title: error.localizedDescription,
                                        message: nil,
                                        preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertVC, animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let  trust =  challenge.protectionSpace.serverTrust {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,  nil)
        }
    }

    //MARK :- <WKUIDelegate>

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let newWebView =  WKWebView(frame: self.view.bounds, configuration: configuration)
        self.setupWebView(newWebView)
        self.addCloseButton(view: newWebView)
        return newWebView
    }

    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertVC = UIAlertController(title: nil,
                                        message: message,
                                        preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) in
            completionHandler()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: nil,
                                        message: message,
                                        preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) in
            completionHandler(true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            completionHandler(false)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        let alertVC = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            completionHandler(nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.cancel, handler: { (action) in
            let text = alertVC.textFields?.first?.text ?? defaultText
            completionHandler(text)
        }))
        alertVC.addTextField(configurationHandler: nil)
        self.present(alertVC, animated: true, completion: nil)
    }

    @available(iOS 10.0, *)
    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
}
