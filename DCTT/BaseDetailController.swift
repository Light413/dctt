//
//  BaseDetailController.swift
//  DCTT
//
//  Created by wyg on 2018/1/26.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class BaseDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {

    var _tableview:UITableView!
    
    private let kSectionViewFooterHeight:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSubview()
        
        addRightNavigationItem()
        
    }
    
    

    //MARK: -
    func initSubview()  {
        _tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 40), style: .grouped)
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 5, 0)
        
        _tableview.separatorStyle = .none
        
        //Register Cell
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        view.addSubview(_tableview)
        
        _tableview.register(UINib (nibName: "HomeDetailCommentCell", bundle: nil), forCellReuseIdentifier: "HomeDetailCommentCellIdentifier")
        
        _tableview.register(UINib (nibName: "HomeDetailImgCell", bundle: nil), forCellReuseIdentifier: "HomeDetailImgCellIdentifier")
        
        //计算Cell高度
        _tableview.estimatedRowHeight = 70
        _tableview.rowHeight = UITableViewAutomaticDimension
        
        //headView
        let headview = Bundle.main.loadNibNamed("HomeDetailHeadView", owner: nil, options: nil)?.last as! HomeDetailHeadView
        _tableview.tableHeaderView = headview
        
        //bottom comment btn
        addBottomBar()
        
    }

    
    //toolBar
    func addBottomBar()  {
        let toolBar = UIToolbar.init(frame: CGRect (x: 0, y: _tableview.frame.maxY, width: kCurrentScreenWidth, height: 40))
        
        let writeBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 120, height: 30))
        writeBtn.setTitle("写评论", for: .normal)
        writeBtn.setTitleColor(UIColor.darkGray, for: .normal)
        writeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        writeBtn.layer.cornerRadius = 15
        writeBtn.layer.borderColor = UIColor.lightGray.cgColor
        writeBtn.layer.borderWidth = 0.5
        writeBtn.layer.masksToBounds = true
        writeBtn.setImage(UIImage (named: "comment"), for: .normal)
        writeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -10, 7, 0)
        writeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        //writeBtn.backgroundColor = UIColor.lightGray //kTableviewBackgroundColor
        writeBtn.tag = 100
        writeBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let writeItem = UIBarButtonItem (customView: writeBtn)
        
        //收藏
        let scBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 80, height: 30))
        scBtn.setImage(UIImage (named: "love_video"), for: .normal)
        scBtn.setImage(UIImage (named: "love_video_press"), for: .selected)
        scBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 50)//2020
        scBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
        scBtn.setTitle("收藏", for: .normal)
        scBtn.setTitle("已收藏", for: .selected)
        scBtn.setTitleColor(UIColor.darkGray, for: .normal)
        scBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        scBtn.tag = 101
        scBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let scItem = UIBarButtonItem (customView: scBtn)
        
        let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [writeItem,flex,scItem]
        
        view.addSubview(toolBar)
    }
    
    func toolBarButtonClicked(_ button:UIButton) {
        button.isSelected = !button.isSelected
        
        switch button.tag {
        case 100://写评论
            break
        case 101://收藏
            break
        case 102://举报
            break
        default:break
        }
    }
 
    
    //MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 ;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
 
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil}
        guard let v = Bundle.main.loadNibNamed("HomeDetailFooterView", owner: nil, options: nil)?.last as? HomeDetailFooterView else{return nil}
        
        return v
        
        
        /*let _v = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kSectionViewFooterHeight))
        
        ////
        let lovebtn = UIButton (frame: CGRect (x: tableView.frame.width - 100, y: 15, width: 80, height: 30))
        lovebtn.layer.cornerRadius = 15
        lovebtn.layer.masksToBounds = true
        lovebtn.layer.borderWidth = 0.5
        lovebtn.layer.borderColor = UIColor.lightGray.cgColor
        
        lovebtn.setImage(UIImage (named: "comment_like_icon_night"), for: .normal)
        lovebtn.setImage(UIImage (named: "comment_like_icon_night"), for: .highlighted)
        _v.addSubview(lovebtn)
        
        ////
        let commentLable =  UILabel (frame: CGRect (x: 10, y: kSectionViewFooterHeight - 25, width: 60, height: 20))
        commentLable.textColor = UIColor.darkGray
        commentLable.font = UIFont.systemFont(ofSize: 13)
        commentLable.text = "评论(20)"
        _v.addSubview(commentLable)
        
        return _v*/
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? kSectionViewFooterHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.01
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
