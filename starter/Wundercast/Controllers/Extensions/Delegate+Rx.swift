//
//  Delegate+Rx.swift
//  Wundercast
//
//  Created by park kyung suk on 2017/10/01.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


//---------------------------------------
//MARK:- DelegateProxy Class
class RxUIWebViewDelegateProxy: DelegateProxy, UIWebViewDelegate, DelegateProxyType {
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let webView: UIWebView = castOrFatalError(object)
        return webView.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let webView: UIWebView = castOrFatalError(object)
        webView.delegate = castOptionalOrFatalError(delegate)
    }
}

//---------------------------------------
//MARK:- Reactive Extension
extension UIWebView {
    
}



//---------------------------------------
// MARK: casts or fatal error

// workaround for Swift compiler bug, cheers compiler team :)
func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: AnyObject) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

func castOrFatalError<T>(_ value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError(message)
    }
    
    return result
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from \(value) to \(T.self)")
    }
    
    return result
}

#if !RX_NO_MODULE
    
    func rxFatalError(_ lastMessage: String) -> Never  {
        // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
        fatalError(lastMessage)
    }
    
#endif
