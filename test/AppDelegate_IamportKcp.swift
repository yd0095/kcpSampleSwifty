//
//  IamportKcp.swift
//  test
//
//  Created by iamport on 07/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//
import UIKit
import WebKit

let MY_APP_SCHEME = "importkcp"

// MARK: - IAMPORT KCP UIApplicationDelegate customization

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
       HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let schemeTmp : String? = url.scheme
        let queryTmp : String? = url.query
        
        if let scheme = schemeTmp {
            //scheme is not nil
            if scheme.hasPrefix(MY_APP_SCHEME) {
                if let query = queryTmp {
                    //query is not nil
                    let queryComponents = URLComponents(string: query)
                    let queryItems = queryComponents?.queryItems
                    let param = queryItems?.filter({$0.name == MY_APP_SCHEME}).first
                    
//                    let imp_uid = queryItems?.filter({$0.name == "imp_uid"}).first?.value
//                    let merchant_uid = queryItems?.filter({$0.name == "merchant_uid"}).first?.value
//                    let m_redirect_url = queryItems?.filter({$0.name == "m_redirect_url"}).first?.value

                    
                    let value = param?.value ?? ""
                    
                    let approval_key_Tmp :String? = value
                    if let approval_key = approval_key_Tmp {
                        //approval_key != nil
                        print("approval_key is \(approval_key)")
                        
                        //range = approval_key.count-4 ... approval_key.count
                        let textStartIndex = approval_key.index(approval_key.endIndex, offsetBy: -4)
                        let textEndIndex = approval_key.endIndex
                        let resultCode = approval_key[textStartIndex ..< textEndIndex]
                        
                        print("reusltCode is \(resultCode)")
                        
                        if resultCode.elementsEqual("0000") {
                            print("ISP인증 성공")
                        }
                        else {
                            print("ISP인증 실패 : \(resultCode)")
                        }
                    }
//                    if m_redirect_url != nil {
//                        print("imp_uid is \(String(describing: imp_uid))")
//                        print("merchant_uid is \(String(describing: merchant_uid))")
//                        print("m_redirect_url is \(String(describing: m_redirect_url))")
//
//
//                    }
                    
                }
                else {
                    //query == nil
                }
            }
        }
        else {
          //scheme == nil
        }       
        // it return void value. Is it important to return non-zero value?
        return true
    }
}

