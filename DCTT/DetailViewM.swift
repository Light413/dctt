//
//  DetailViewM.swift
//  DCTT
//
//  Created by wyg on 2018/9/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift

class DetailViewM: NSObject {
    var category:String!
    var type:String!
    
    var tableView:UITableView {
        get{
            return _tableview;
        }
    }
    
    var headView:HomeDetailHeadView!
    ///评论数
    var _commentNumber:UILabel!
    ///收藏按钮
    var _isScBtn:UIButton!
    
    private var _tableview:UITableView!
    private var pid:String!
    private var targetAction:Selector!
    private weak var superController:UIViewController?
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - vc: 所属视图的控制器
    ///   - action: nil
    init(_ vc:BaseDetailController? , action:Selector? = nil) {
        super.init()
        
        superController = vc
        pid = vc?.pid
        targetAction = #selector(toolBarButtonClicked(_:))
        
        _tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - kNavigationBarHeight - kBottomToolBarHeight), style: .grouped)
        _tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        _tableview.showsVerticalScrollIndicator = false
        _tableview.separatorStyle = .none
        _tableview.backgroundColor = UIColor.white
        
        //Register Cell
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        superController?.view.addSubview(_tableview)
        
        _tableview.register(UINib (nibName: "HomeDetailCommentCell", bundle: nil), forCellReuseIdentifier: "HomeDetailCommentCellIdentifier")
        //_tableview.register(UINib (nibName: "HomeDetailImgCell", bundle: nil), forCellReuseIdentifier: "HomeDetailImgCellIdentifier")
        _tableview.register(UINib (nibName: "HomeDetailImgCell3", bundle: nil), forCellReuseIdentifier: "HomeDetailImgCell3Identifier")
        
        //计算Cell高度
        _tableview.estimatedRowHeight = 70
        _tableview.rowHeight = UITableView.automaticDimension
        
        //HeadView
        let headview = Bundle.main.loadNibNamed("HomeDetailHeadView", owner: nil, options: nil)?.last as! HomeDetailHeadView
        _tableview.tableHeaderView = headview

        if let data = vc?.data {
            headview.fill(data)
            headview.avatarClickedAction = {[weak self] in
                guard let ss = self else { return}
                let vc = MeHomePageController.init(style:.plain)
                if let uid = data["uid"] as? String {
                    vc.uid = uid
                }
                
                ss.superController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        

        
        headView = headview
        
        self.addBottomBar()
    }
    

    //toolBar
    func addBottomBar()  {
        let toolBar = UIToolbar.init(frame: CGRect (x: 0, y: _tableview.frame.maxY, width: kCurrentScreenWidth, height: 49))
        toolBar.barTintColor = tt_defafault_barColor //UIColor.white
        
        let btn_frame = CGRect (x: 0, y: 10, width: 120, height: 30)
        let writeBtn = UIButton (frame: btn_frame)
        writeBtn.setTitle("我要评论...", for: .normal)
        writeBtn.setTitleColor(UIColor.darkGray, for: .normal)
        writeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        writeBtn.layer.cornerRadius = 5
        writeBtn.layer.masksToBounds = true
        writeBtn.backgroundColor = UIColor.white
        writeBtn.setImage(UIImage (named: "writeicon_review_dynamic"), for: .normal);
        writeBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 50)
        writeBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        writeBtn.tag = 100
        writeBtn.addTarget(self, action: targetAction, for: .touchUpInside)
        let writeItem = UIBarButtonItem (customView: writeBtn)
        
        //评论数
        let commentNumber = UIButton (frame: CGRect (x: 0, y: 10, width: 60, height: 30))
        commentNumber.setTitleColor(UIColor.darkGray, for: .normal)
        commentNumber.layer.cornerRadius = 5
        commentNumber.layer.masksToBounds = true
        commentNumber.setImage(UIImage (named: "tab_comment"), for: .normal);
        commentNumber.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        commentNumber.tag = 101
        //commentNumber.addTarget(self, action: targetAction, for: .touchUpInside)
        
        let numLable = UILabel()
        numLable.font = UIFont.systemFont(ofSize: 8)
        numLable.textColor = UIColor.white
        numLable.textAlignment = .center
        numLable.backgroundColor = kButtonTitleColor
        numLable.layer.cornerRadius = 5
        numLable.layer.masksToBounds = true
        //numLable.sizeToFit()
        _commentNumber = numLable
        
        commentNumber.addSubview(numLable)
        let commentNumberItem = UIBarButtonItem (customView: commentNumber)
        
        //收藏
        let scBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 80, height: 35))
        scBtn.setImage(UIImage (named: "likeicon_actionbar_details"), for: .normal)
        scBtn.setImage(UIImage (named: "likeicon_actionbar_details_press"), for: .selected)
        scBtn.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 45)
        scBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 0)
        scBtn.setTitle("收藏", for: .normal)
        scBtn.setTitle("已收藏", for: .selected)
        scBtn.setTitleColor(UIColor.darkGray, for: .normal)
        scBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        scBtn.tag = 102
        scBtn.addTarget(self, action: targetAction, for: .touchUpInside)
        
        _isScBtn = scBtn
        let scItem = UIBarButtonItem (customView: scBtn)
        
        let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [writeItem,commentNumberItem,flex,scItem]
        
        superController?.view.addSubview(toolBar)
    }
    
    @objc func toolBarButtonClicked(_ button:UIButton) {
        guard User.isLogined() else {
            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
            return
        }

        switch button.tag {
        case 100://写评论
//            IQKeyboardManager.sharedManager().enable = false
//            IQKeyboardManager.sharedManager().enableAutoToolbar = false
            let post_v = TTPostCommentView.init(frame:UIScreen.main.bounds)
            post_v.pid = pid
            post_v.category = category
            
            UIApplication.shared.keyWindow?.addSubview(post_v)
            break
        case 102://收藏
            HUD.show()
            
            let d = ["pid":pid! ,
                     "type": button.isSelected ? "3" : "2" ,
                     "uid":User.uid()!,
                     "category":category!,
                     "subType" : type!
            ]
            
            AlamofireHelper.post(url: post_detail_url, parameters: d, successHandler: { (res) in
                button.isSelected = !button.isSelected
                
                HUD.show(successInfo: button.isSelected ? "收藏成功" : "取消收藏")
            }) { (error) in
                HUD.show(info: "请求失败,请稍后重试")
            }
            
            
            break
        case 103://举报
            
            break
        default:break
        }
    }
    
    
    deinit {
        //print(self.description + " deinit")
    }
}
