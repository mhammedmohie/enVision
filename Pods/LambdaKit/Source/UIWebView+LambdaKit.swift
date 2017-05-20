//
//  UIWebView+LamdaKit.swift
//  Created by Martin Conte Mac Donell on 3/31/15.
//
//  Copyright (c) 2015 Lyft (http://lyft.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

public typealias LKShouldStartClosure = (UIWebView, URLRequest, UIWebViewNavigationType) -> Bool
public typealias LKDidStartClosure = (UIWebView) -> Void
public typealias LKDidFinishLoadClosure = (UIWebView) -> Void
public typealias LKDidFinishWithErrorClosure = (UIWebView, NSError) -> Void

// A global var to produce a unique address for the assoc object handle
private var associatedEventHandle: UInt8 = 0

/// Closure support for UIWebView.
///
/// Example:
///
/// ```swift
/// let webView = UIWebView() webView.shouldStartLoad = { webView, request, type in
///     print("shouldStartLoad: \(request)")
///     return true
/// }
///
/// webView.didStartLoad = { webView in
///     print("didStartLoad: \(webView)")
/// }
///
/// webView.didFinishLoad = { webView in
///     print("didFinishLoad \(webView)")
/// }
///
/// webView.didFinishWithError = { webView, error in
///     print("didFinishWithError \(error)")
/// }
/// ```
///
/// WARNING: You cannot use closures *and* set a delegate at the same time. Setting a delegate will prevent
/// closures for being called and setting a closure will overwrite the delegate property.
extension UIWebView: UIWebViewDelegate {
    private var closuresWrapper: ClosuresWrapper {
        get {
            if let wrapper = objc_getAssociatedObject(self, &associatedEventHandle) as? ClosuresWrapper {
                return wrapper
            }

            let closuresWrapper = ClosuresWrapper()
            self.closuresWrapper = closuresWrapper
            return closuresWrapper
        }

        set {
            self.delegate = self
            objc_setAssociatedObject(self, &associatedEventHandle, newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The closure to be decide whether a URL will be loaded.
    public var shouldStartLoad: LKShouldStartClosure? {
        set { self.closuresWrapper.shouldStartLoad = newValue }
        get { return self.closuresWrapper.shouldStartLoad }
    }

    /// The closure that is fired when the web view starts loading.
    public var didStartLoad: LKDidStartClosure? {
        set { self.closuresWrapper.didStartLoad = newValue }
        get { return self.closuresWrapper.didStartLoad }
    }

    /// The closure that is fired when the web view finishes loading.
    public var didFinishLoad: LKDidFinishLoadClosure? {
        set { self.closuresWrapper.didFinishLoad = newValue }
        get { return self.closuresWrapper.didFinishLoad }
    }

    /// The closure that is fired when the web view stops loading due to an error.
    public var didFinishWithError: LKDidFinishWithErrorClosure? {
        set { self.closuresWrapper.didFinishWithError = newValue }
        get { return self.closuresWrapper.didFinishWithError }
    }

    // MARK: UIWebViewDelegate implementation

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest,
        navigationType: UIWebViewNavigationType) -> Bool
    {
        return self.shouldStartLoad?(webView, request, navigationType) ?? true
    }

    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.didStartLoad?(webView)
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.didFinishLoad?(webView)
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.didFinishWithError?(webView, error as NSError)
    }
}

// MARK: - Private classes

fileprivate final class ClosuresWrapper {
    fileprivate var shouldStartLoad: LKShouldStartClosure?
    fileprivate var didStartLoad: LKDidStartClosure?
    fileprivate var didFinishLoad: LKDidFinishLoadClosure?
    fileprivate var didFinishWithError: LKDidFinishWithErrorClosure?
}
