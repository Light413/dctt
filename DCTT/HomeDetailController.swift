//
//  HomeDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeDetailController: BaseDetailController{

    var data:[String:Any]!
    var imgArr = [String]()
    
    var isPreview:Bool = false //是否处于预览状态
    
    ////....test
    var pre_text:String!
    var pre_imgs = [UIImage]()
    
    private var _titleView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tableview.register(UINib (nibName: "HomeDetailImgCell3", bundle: nil), forCellReuseIdentifier: "HomeDetailImgCell3Identifier")
        
        //titleview
        _titleView = titleView()
        _titleView.isHidden = true
        navigationItem.titleView = _titleView

        fillData()
        
    }

    func fillData()  {
        headView.fill(data)
        headView.avatarClickedAction = {[weak self] in
           let vc = MeHomePageController.init(style:.plain)
            guard let ss = self else {
                return
            }
            
            if let uid = ss.data["uid"] as? String {
                vc.uid = uid
            }
            
            ss.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        let images = String.isNullOrEmpty(data["images"])
        if images.lengthOfBytes(using: String.Encoding.utf8) > 50 {
           let arr = images.components(separatedBy: ",")
            if arr.count > 0 {
                imgArr = imgArr + arr
            }
        }
        

    }
    
    
    
    func loadComment() {
        
    }
    
    
    //MARK: -
    
    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 30, height: 30))

        let icon = UIImageView (frame: CGRect (x: 0, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        icon.image = UIImage (named: "avatar_default")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        //icon
        if let dic = data["user"] as? [String:Any]{
            if let igurl = dic["avatar"] as? String {
                let url = URL.init(string: igurl)
                icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }

        
        //....
        let btn = UIButton (frame: CGRect (x: icon.frame.maxX + 10, y: 0, width: 60, height: 25))
        btn.backgroundColor = UIColor (red: 17/255.0, green: 135/255.0, blue: 212/255.0, alpha: 1)
        btn.setTitle("关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(watchBtnAction), for: .touchUpInside)
        //_bgview.addSubview(btn)
        
        return _bgview
    }
    
    func watchBtnAction() {
        //关注
        
    }
    
    
    //MARK: - 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _titleView.isHidden = !(scrollView.contentOffset.y > 60)
    }
    
    
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int { return 2}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 +  lroundf(ceilf(Float(imgArr.count) / 3.0) ) // + pic 个数
        }else{
        
            return 5 //评论数
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let _text = String.isNullOrEmpty(data["content"])
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = UIColor.darkGray
                
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 5
                paragraphStyle.lineBreakMode = .byCharWrapping
                paragraphStyle.firstLineHeadIndent = 15
                
                let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 17) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
                let attriStr = NSAttributedString.init(string: _text, attributes: dic)
                cell.textLabel?.attributedText = attriStr
            }else{//带有图的cell
                cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailImgCell3Identifier", for: indexPath) as! HomeDetailImgCell3

                /////
                let row = indexPath.row - 1
                let igs = imagesWithIndex(row)
                (cell as! HomeDetailImgCell3).tapActionHandler = {[weak self] i in
                    if  let ss = self {
                        let index = row * 3 + i
                        let vc  = TTImagePreviewController2()
                        vc.index = index - 1
                        vc.dataArry = ss.imgArr
                        
                        ss.navigationController?.present(vc, animated: false, completion: nil)
                    }
                    
                }
                
                (cell as! HomeDetailImgCell3).fill(igs)

            }
        }else{
             cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        }
        

        cell.selectionStyle = .none
        
        return cell
    }
    
    deinit {
        print("123")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = HomeDetailController()
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil}
        guard let v = Bundle.main.loadNibNamed("HomeDetailFooterView", owner: nil, options: nil)?.last as? HomeDetailFooterView else{return nil}
        
        return v
    }
    
    
    //MARK: -
    func imagesWithIndex(_ index:Int) -> [String] {
        var arr = [String]()
        for i in index * 3 ..< imgArr.count{
            let origin = imgArr[i]
            arr.append(origin)
            if arr.count >= 3 {
                break
            }
        }
        
        return arr
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section > 0 {
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
