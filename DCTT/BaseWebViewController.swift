//
//  BaseWebViewController.swift
//  mcs
//
//  Created by gener on 2018/1/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseWebViewController: BaseViewController,UIWebViewDelegate,UIGestureRecognizerDelegate {

    private var webview: UIWebView!
    private var _url:String!
    
    init(baseUrl url :String) {
        super.init(nibName: nil, bundle: nil)
        _url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _addNavigationItems()
        
        webview = UIWebView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64))
        webview.delegate = self
        //webview.scrollView.bounces = false
        webview.backgroundColor = UIColor.white //kTableviewBackgroundColor;
        view.addSubview(webview)
        
        ////add UILongPressGestureRecognizer
        let longpress = UILongPressGestureRecognizer.init(target: self, action: nil)
        longpress.minimumPressDuration = 0.1
        longpress.delegate = self
        webview.addGestureRecognizer(longpress)
        
        let req = URLRequest.init(url: URL.init(string: BASE_URL + _url!)!)
        
        HUD.show()
        webview.loadRequest(req)
    }

    private func _addNavigationItems() {
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        msgBtn.addTarget(self, action: #selector(_refreshAction), for: .touchUpInside)
        msgBtn.setImage(UIImage (named: "refreshicon_dynamic_titlebar"), for: .normal);
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 18, 13, 18)
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 15
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        navigationItem.rightBarButtonItems = [fixed,msgItem]
    }
    
    
    func _refreshAction() {
        
        loadData()
        
    }
    
    func loadData() {
        
        webview.reload()
    }
    

    //MARK:
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //MARK:
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
