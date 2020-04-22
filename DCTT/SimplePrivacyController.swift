//
//  SimplePrivacyController.swift
//  DCTT
//
//  Created by wyg on 2018/11/6.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class SimplePrivacyController: BaseViewController , UITextViewDelegate {

    @IBOutlet weak var msg: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    @IBAction func userOperationAction(_ sender: UIButton) {
   
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        UserDefaults.standard.set("1", forKey:"isFirstLaunch")
        UserDefaults.standard.synchronize()
        
        let s = "本《隐私概要》将向你说明:\n1.为了帮助你浏览、发布信息、评论交流、注册认证，我们会收集你的部分必要信息;\n\n2.为了提供以上服务，我们可能会收集联络方式、位置、通讯录等部分敏感信息，你有权拒绝或撤销授权;\n\n3.未经你同意，我们不会从第三方获取、共享或提取你的信息;\n\n4.你可以访问、更正、删除你的个人信息，我们也将提供注销、投诉的方式。如果你点击不同意，我们将仅收集浏览内容所必须的信息，但发布信息、交流评论可能会受到影响。\n\n前往查看完整的 隐私政策"
        
        let attri = NSMutableAttributedString.init(string: s)
        
//        attri.addAttributes([NSForegroundColorAttributeName:UIColor.red ], range: NSRange.init(location: s.count - 4, length: 4))
        
        attri.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange.init(location: 0, length: s.count))
        
        attri.addAttribute(NSAttributedString.Key.link, value:NSURL.init(string: "dctt:p/userPrivacy.html")!, range: NSRange.init(location: s.count - 4, length: 4) )
        
        msg.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColorFromHex(rgbValue: 0xff4500) ])
        
        msg.attributedText = attri;
        msg.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {        
        if let scheme = URL.scheme , scheme == "dctt" {
            let vc = BaseWebViewController(baseUrl:privacy_agreement_url)
            vc.title = "隐私政策"

            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
