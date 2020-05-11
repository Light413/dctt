//
//  BaseWebViewController.swift
//  mcs
//
//  Created by gener on 2018/1/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController,WKNavigationDelegate,UIGestureRecognizerDelegate {

    private var webview: WKWebView!
    private var _url:String!
    private var _isFullUrl:Bool = false
    
    init(baseUrl url :String ,isFullUrl:Bool = false) {
        super.init(nibName: nil, bundle: nil)
        _url = url
        _isFullUrl = isFullUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let b = self.navigationController?.navigationBar.isHidden , b{
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _addNavigationItems()
        webview = WKWebView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64));
        
        webview.navigationDelegate = self
        //webview.scrollView.bounces = false
        webview.backgroundColor = UIColor.white //kTableviewBackgroundColor;
        view.addSubview(webview)
        
        ////add UILongPressGestureRecognizer
        let longpress = UILongPressGestureRecognizer.init(target: self, action: nil)
        longpress.minimumPressDuration = 0.1
        longpress.delegate = self
        webview.addGestureRecognizer(longpress)
        
        var req = URLRequest.init(url: URL.init(string: _isFullUrl ? _url! : BASE_URL + _url!)!)
        req.cachePolicy = .reloadIgnoringLocalCacheData
        HUD.show()
        webview.load(req)
    }

    private func _addNavigationItems() {
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        msgBtn.addTarget(self, action: #selector(_refreshAction), for: .touchUpInside)
        msgBtn.setImage(UIImage (named: "refreshicon_dynamic_titlebar"), for: .normal);
        msgBtn.imageEdgeInsets = UIEdgeInsets.init(top: 13, left: 18, bottom: 13, right: 18)
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 15
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        navigationItem.rightBarButtonItems = [fixed,msgItem]
    }
    
    
    @objc func _refreshAction() {
        
        loadData()
        
    }
    
    func loadData() {
        
        webview.reload()
    }
    

    //MARK:
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    //MARK:WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("%s" , #function);
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil);
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil);
        
        HUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        HUD.show(info: error.localizedDescription)
    }
    
    
    
    //MARK:-- uiwebviewdelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 禁用用户选择
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        
        // 禁用长按弹出框
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
 
        HUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
        HUD.show(info: error.localizedDescription)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
