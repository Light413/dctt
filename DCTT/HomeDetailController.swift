//
//  HomeDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var _tableview:UITableView!
    var _titleView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
    
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
        
        
        //titleview
        _titleView = titleView()
        _titleView.isHidden = true
        navigationItem.titleView = _titleView
        
        //bottom comment btn
        addBottomBar()
        
    }
    
    //toolBar
    func addBottomBar()  {
        let toolBar = UIToolbar.init(frame: CGRect (x: 0, y: _tableview.frame.maxY, width: kCurrentScreenWidth, height: 40))

        let writeBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 100, height: 30))
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
        writeBtn.backgroundColor = kTableviewBackgroundColor
        writeBtn.tag = 100
        writeBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let writeItem = UIBarButtonItem (customView: writeBtn)
        
        //收藏
        let scBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 40, height: 30))
        scBtn.setImage(UIImage (named: "product_comment"), for: .normal)
        scBtn.setImage(UIImage (named: "product_comment_click"), for: .selected)
        scBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        scBtn.tag = 101
        scBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let scItem = UIBarButtonItem (customView: scBtn)
        
        let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //举报
        let jbBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 30))
        jbBtn.setTitle("举报", for: .normal)
        jbBtn.setTitleColor(UIColor.lightGray, for: .normal)
        jbBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jbBtn.tag = 102
        jbBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let jcItem = UIBarButtonItem (customView: jbBtn)
        

        
        toolBar.items = [writeItem,flex,scItem,flex,jcItem]
        
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
    
    
    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 100, height: 25))

        let icon = UIImageView (frame: CGRect (x: 0, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        icon.image = UIImage (named: "ymtimg2.jpg")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        let btn = UIButton (frame: CGRect (x: icon.frame.maxX + 10, y: 0, width: 60, height: 25))
        btn.backgroundColor = UIColor (red: 17/255.0, green: 135/255.0, blue: 212/255.0, alpha: 1)
        btn.setTitle("关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(watchBtnAction), for: .touchUpInside)
        _bgview.addSubview(btn)
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 + 2 // + pic 个数
        }else{
        
        return 5 //评论数
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let _text = "在具体使用的使用向WizDataBaseManager请求一个WizDataBase，然后使用。在这特意提一下一种常见的数据库应用场景，就是在使用MVC的使用模型控制器从数据库中读取数据然后去更新UI。读取数据库当然是一个很费事的操作，如果让主线程一直忙于读取数据库的话，将会降低UI的响应"
                
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = UIColor.darkGray
                
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 5
                paragraphStyle.lineBreakMode = .byCharWrapping
                paragraphStyle.firstLineHeadIndent = 20
                
                let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 16) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
                let attriStr = NSAttributedString.init(string: _text, attributes: dic)
                cell.textLabel?.attributedText = attriStr
            }else{//带有图的cell
                cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailImgCellIdentifier", for: indexPath)
                
            }

        }else{
             cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        }
        

        cell.selectionStyle = .none
        
        return cell
    }
    
    
    let _footerHeight:CGFloat = 80
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let _v = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _footerHeight))
        
        ////
        let zanbtn = UIButton (frame: CGRect (x: (kCurrentScreenWidth - 200 - 50)/2, y: 10, width: 100, height: 30))
        zanbtn.layer.cornerRadius = 15
        zanbtn.layer.masksToBounds = true
        zanbtn.layer.borderWidth = 0.5
        zanbtn.layer.borderColor = UIColor.lightGray.cgColor
        
        zanbtn.setImage(UIImage (named: "comment_like_icon_night"), for: .normal)
        zanbtn.setImage(UIImage (named: "comment_like_icon_night"), for: .highlighted)
        _v.addSubview(zanbtn)
        
        ////
        let lovebtn = UIButton (frame: CGRect (x: zanbtn.frame.maxX + 50, y: 10, width: 100, height: 30))
        lovebtn.layer.cornerRadius = 15
        lovebtn.layer.masksToBounds = true
        lovebtn.layer.borderWidth = 0.5
        lovebtn.layer.borderColor = UIColor.lightGray.cgColor
        
        lovebtn.setImage(UIImage (named: "step"), for: .normal)
        lovebtn.setImage(UIImage (named: "step"), for: .highlighted)
        _v.addSubview(lovebtn)
        
        ////
        let commentLable =  UILabel (frame: CGRect (x: 10, y: _footerHeight - 25, width: 60, height: 20))
        commentLable.textColor = UIColor.darkGray
        commentLable.font = UIFont.systemFont(ofSize: 13)
        commentLable.text = "评论(20)"
        _v.addSubview(commentLable)
        
        return _v
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? _footerHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
