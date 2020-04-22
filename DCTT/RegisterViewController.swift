//
//  RegisterViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
let seconds = 60;
let _keyWindow = UIApplication.shared.keyWindow!

class RegisterViewController: UITableViewController {
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var repwd: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    ///注册或修改密码(默认注册操作)
    var isRegisterAction:Bool = true
    let getCodeBtnBgColorDefault = UIColorFromHex(rgbValue: 0xC70F2B)
    let getCodeBtnBgColorSelected = UIColor.darkGray;
    var _timer:Timer!
    var _cnt = seconds
    let disposeBag = DisposeBag.init();
    
    ///选中同意用户协议
    @IBOutlet weak var selectedBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isRegisterAction ? "用户注册" : "修改密码";
        registerBtn.setTitle(isRegisterAction ? "注册" : "修改", for: .normal)
        
        _timer = Timer.init(timeInterval: 1, target: self, selector:  #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer, forMode: RunLoop.Mode.common)
        _timer.fireDate = Date.distantFuture
        
        ///////
        let phone_obserable =  phone.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        let code_obserable =  code.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        let pwd_obserable =  pwd.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) >= 6}.shareReplay(1)
        let repwd_obserable =  repwd.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        
        Observable.combineLatest(phone_obserable, code_obserable, pwd_obserable, repwd_obserable) { $0 && $1 && $2 && $3 }.subscribe {[weak self] (e) in
            guard let  ss = self else {return}
            if let b = e.element {
                ss.registerBtn.isEnabled = b
                ss.registerBtn.backgroundColor = b ?  UIColorFromHex(rgbValue: 0xC70F2B) : kTableviewBackgroundColor
            }
        }.addDisposableTo(disposeBag)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _timer.invalidate()
    }
    
    deinit {
        _timer = nil
    }
    
    @objc func timerAction()  {
        guard _cnt > 0 else {
            _cnt = seconds
            _timer.fireDate = Date.distantFuture
            getCodeBtn.setTitle("获取验证码", for: .normal)
            getCodeBtn.setTitleColor(getCodeBtnBgColorDefault, for: .normal)
            getCodeBtn.isEnabled = true;
            return
        }
        
        _cnt = _cnt - 1
        getCodeBtn.setTitle("\(_cnt)s", for: .normal)
        print(_cnt)
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://获取验证码
            guard sender.isEnabled else {return}
            guard String.isNullOrEmpty(phone.text).lengthOfBytes(using: String.Encoding.utf8) == 11 else {HUD.showText("输入正确的手机号码", view: UIApplication.shared.keyWindow!); return}
            
            sender.isEnabled = false
            getCodeBtn.setTitle("\(_cnt)s", for: .normal)
            getCodeBtn.setTitleColor(getCodeBtnBgColorSelected, for: .normal)
            _timer.fireDate = Date.distantPast
            
            ///获取验证码
            AlamofireRequest(get_checkcode_url, parameter: ["phoneNumber":String.isNullOrEmpty(phone.text)]) { (res) in
                HUD.showText("已发送验证码", view: UIApplication.shared.keyWindow!)
            }
            break
            
        case 2://注册/修改密码
            guard String.isNullOrEmpty(pwd.text) == String.isNullOrEmpty(repwd.text) else {
                HUD.showText("两次密码不一致", view: UIApplication.shared.keyWindow!); return
            }
            
            guard String.isNullOrEmpty(code.text).lengthOfBytes(using: String.Encoding.utf8) == 4 else {
                HUD.showText("请输入正确的验证码", view: kAPPKeyWindow!); return;
            }
            
            ///注册操作,是否同意用户协议
            if isRegisterAction {
                guard selectedBtn.isSelected else {
                    HUD.showText("请阅读并同意用户协议", view: kAPPKeyWindow!);return
                }
            }

           HUD.show();
            var d = ["phone_number":String.isNullOrEmpty(phone.text),
                     "pwd":String.isNullOrEmpty(pwd.text),
                     "code":String.isNullOrEmpty(code.text)
                     ]
            
            if !isRegisterAction {
                d["isModify"] = "1";
            }
            
            ///注册-找回密码
            AlamofireRequest(register_url, parameter: d , successHandler : { [weak self](res) in
                HUD.show(successInfo:"操作成功,请前往登录")
                
                guard let ss = self else {return}
                ss.navigationController?.popViewController(animated: true)
            });break
            
        case 3:
            let vc = BaseWebViewController(baseUrl:user_agreement_url)
            vc.title = "用户协议"
            self.navigationController?.pushViewController(vc, animated: true); break
            
        case 4:
            let vc = BaseWebViewController(baseUrl:privacy_agreement_url)
            vc.title = "隐私政策"
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case 5: sender.isSelected = !sender.isSelected; break
        default:break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else {
            return isRegisterAction ?  2 : 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
