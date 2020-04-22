//
//  PubBaseTableViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/1.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class PubBaseTableViewController: UITableViewController,ShowAlertControllerAble{
    var t_barTintColor:UIColor?
    
    ///发布按钮
    var publishBtn:UIButton!
    ///发布内容
    var sourceTextView:UITextView!
    ///选择的图片
    var imgDataArr = [Any]()
    ///发布类型信息
    var typeInfo:[String:String]?
    var typeId:String!
    
    let disposeBag = DisposeBag.init();
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = tt_bg_color
        navigationItem.leftBarButtonItem = leftNavigationItem()
        navigationItem.rightBarButtonItem = rightNavigationItem()

        tableView.showsVerticalScrollIndicator = false
        
        if let _info = typeInfo , let type = _info["item_key"] {
            typeId = type
            
            title = _info["item_title"]
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _addObserve(sourceTextView)
        
        ///弹框提示已同意用户协议
        showTipsBeforePublish()

    }
    
    func _addObserve(_ source:UITextView) {
        let obserable =  source.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        
        obserable.bindTo(publishBtn.ex_isEnabled).addDisposableTo(disposeBag);
    }
    
    func leftNavigationItem() -> UIBarButtonItem {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 30))
        leftbtn.setTitle("取消", for: .normal)
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        return leftitem;
    }
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 30))
        rightbtn.setTitle("发布", for: .normal)
        rightbtn.setTitleColor(UIColor.lightGray , for: .normal)//kAirplaneCell_head_selected_color
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(submintBtnAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        publishBtn = rightbtn
        
        return rightitem
    }
    
    
    
    //MARK: - Actions
    @objc func submintBtnAction(){
        willPost()
        guard imgDataArr.count > 0 else {startPost(); return}
        
        var images = [UIImage]()
        //获取相册图片
        let requestOption = PHImageRequestOptions.init()
        requestOption.resizeMode = .fast
        requestOption.isSynchronous = true
        let size = CGSize(width: 400, height: 400)
        let group = DispatchGroup.init()
        
        for i in 0..<imgDataArr.count {
            let obj = imgDataArr[i]
            
            group.enter()
            if obj is PHAsset {
                PHImageManager.default().requestImage(for: obj as! PHAsset, targetSize: size, contentMode: .aspectFit, options: requestOption, resultHandler: {(img, dic) in
                    if let ig = img{
                        images.append(ig)
                    }
                    
                    group.leave()
                })
            }else if obj is UIImage {
                images.append(obj as! UIImage);
                group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) {[weak self ] in
            guard let ss = self else {return}
            ss.startPost(images)
        }
        
    }
    
    ///将要发布的预处理,有子类实现具体操作
    func willPost() {}
    func startPost(_ ig:[UIImage]? = nil) {}
    
    //有子类调用，请求网络
    func _post(_ uid:String , pars:[String:Any],ig:[UIImage]? = nil)  {
        var contentJsonStr = ""
        do{
            let data = try JSONSerialization.data(withJSONObject: pars, options: []);
            contentJsonStr = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        }catch{
            print(error.localizedDescription)
        }
        
        
        HUD.show()
        let d = ["uid":uid,
                 "content":String.isNullOrEmpty(contentJsonStr),
                 "type":typeId!]
        
        AlamofireHelper.upload(to: publish_url, parameters: d, uploadFiles: ig, successHandler: { [weak self] (res) in
            HUD.show(successInfo: "发布成功!");
            guard let ss = self else {return}
            
            let vc = UIAlertController.init(title: "发布成功",message: "感谢你的参与，系统24小时内进行审核通过后才会显示", preferredStyle: .alert);
            let action2 = UIAlertAction.init(title: "我知道了", style: .default) { (action) in
                NotificationCenter.default.post(name: kHasPublishedSuccessNotification, object: nil, userInfo: ["type":ss.typeId!]);
                ss.dismiss(animated: true, completion: nil)
            }
            
            vc.addAction(action2)
            ss.navigationController?.present(vc, animated: true, completion: nil);
        }) {
            print("upload faile");
        }
    }
    
    
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
