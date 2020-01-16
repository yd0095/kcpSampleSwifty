//
//  ViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController {


    @IBOutlet weak var myWebView: WKWebView!
    
    func loadWebPage(url: String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
        
        //this is a program which just opens the website that is mentioned in github
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myWebView.navigationDelegate = self
        // Do any additional setup after loading the view.
        loadWebPage(url : "https://www.iamport.kr/demo")
        
        //myWebView.
        
    }
    
    func landRedirectUrl (_ landing_url : String){
        let url :URL? = URL(string: landing_url)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "GET"
        myWebView.load(request)
    }
    
}


// MARK: - IAMPORT KCP WEBVIEW TO CHECK ISP AND URL FROM OTHER REQUEST

extension ViewController: WKNavigationDelegate {
//shouldStartLoadWithRequest webkit ver
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // decisionHandler 중복호출을 피하기위한 closure 작성하여 policy를 도출
        let navigationPolicyBasedOnUrlScheme = { () -> WKNavigationActionPolicy in
        
            let request = navigationAction.request
            //let url != nil didn't consider about when url is nil.
            let urlString = request.url!.absoluteString
            
            let bAppStoreURL : Bool = urlString.range(of: "phobos.apple.com") != nil
            let bAppStoreURL2 : Bool = urlString.range(of: "itunes.apple.com") != nil
            
            if bAppStoreURL || bAppStoreURL2 {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil) //?
                return .cancel
            }
            //isp 호출
            if urlString.hasPrefix("ispmobile://") {
                let appURL :URL? = URL(string: urlString)
                if UIApplication.shared.canOpenURL(appURL!) {
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                } else {
                    //alert
                    self.showAlertViewWithEvent("모바일 ISP가 설치되어 있지 않아 \n App Store로 이동합니다.", tagNum: 99)
                    return .cancel
                }
            }
            
            //기타(금결원 실시간계좌이체 등
            let strHttp: String = "http://"
            let strHttps: String = "https://"
            let reqUrl : String? = request.url!.absoluteString
            print("webview에 요청된 url==> \(reqUrl!)")
            
            if reqUrl?.hasPrefix(strHttp) != true && reqUrl?.hasPrefix(strHttps) != true {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
                return .cancel
            }
            return .allow
        }
        
        decisionHandler(
            navigationPolicyBasedOnUrlScheme())
    }
}

// MARK: - IAMPORT KCP ALERT To Open ISP DOWNLOAD URL FROM APP STORE

extension ViewController: UIAlertViewDelegate {

    func showAlertViewWithEvent(_ msg : String, tagNum tag : Int) {
        let alert : UIAlertController = UIAlertController(title: "알림", message: "_msg", preferredStyle: .alert)
        
        alert.view.tag = tag
        
        let okAction = UIAlertAction(title :"확인",style: .default, handler: {
            ACTION in
            if alert.view.tag == 99 {
              let URLstring : String = "https://itunes.apple.com/app/mobail-gyeolje-isp/id369125087?mt=8"
                let storeURL : URL = URL(string: URLstring)!
                UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(okAction)
        alert.present(alert, animated: true, completion: nil)
    }
}
