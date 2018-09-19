//
//  BaseDetailController.swift
//  DCTT
//
//  Created by wyg on 2018/1/26.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BaseDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    ///详情ID
    var pid:String!
    
    ///动态详情数据
    var data:[String:Any]!
    
    ///评论
    var commentDataArr = [[String:Any]]()
    
    var _tableview:UITableView!

    var headView:HomeDetailHeadView!
    var headFooterView:HomeDetailFooterView!
    private let kSectionViewFooterHeight:CGFloat = 150
    private var _commentNumber:UILabel!
    private var _readCnt:[String:Any]?
    private var _isScBtn:UIButton! //是否收藏
    private var viewModel:DetailViewM!
    private var imgArr = [String]();
    
    ///设置评论数
    var commentNumbers:Int {
        get{
            return 0
        }
        
        set{
            let num:NSString = NSString.init(string: "\(newValue)")
            _commentNumber.text = String.init(num)
            
            let size = num.boundingRect(with: CGSize.init(width: 50, height: 10), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:_commentNumber.font], context: nil)
            _commentNumber.frame = CGRect (x: 30, y: 2, width: size.width + 10, height: 10)
        }
    }
    

    //MARK: - Load data
    //阅读量，点赞
    func loadReadCnt() {
        //...未登录的问题还没处理
        
        
        AlamofireHelper.post(url: post_detail_url, parameters: ["pid":pid! , "type":"0","uid":User.uid()!], successHandler: {[weak self] (res) in
            guard let body = res["body"] as? [String:Any] else {return}
            guard let ss = self else {return}
            if let footview = ss.headFooterView {
              footview.fill(body)
            }
            
            ss._readCnt = body
            
            //是否收藏
            ss._isScBtn.isSelected = String.isNullOrEmpty(body["sc"]) == "1"
            
        }) { (error) in
            //HUD.dismiss()
        }
        
    }
    
    ///获取评论
    func loadComment() {
        let d = ["type":"get","pid":pid!]
        
        AlamofireHelper.post(url: comment_url, parameters: d, successHandler: {[weak self] (res) in
            guard let arr = res["body"] as? [[String:Any]] else {return}
            guard let ss = self else {return}
            
            ss.commentDataArr.removeAll()
            
            ss.commentDataArr = ss.commentDataArr + arr
            if arr.count > 0 {
                ss.commentNumbers = ss.commentDataArr.count;
            }
            
            //无动画刷新列表
            UIView.performWithoutAnimation {
                ss._tableview.reloadSections([1], with: .none)

            }
            
        }) { (err) in
            HUD.show(info: "获取评论失败,请稍后重试")
            print(err?.localizedDescription);
            
            //点击重试
        }
        
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initSubview()
        
        addRightNavigationItem()
        
        loadReadCnt()
        
        getImages()

    }

    init(_ _id:String) {
        super.init(nibName: nil, bundle: nil)
        pid = _id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview()  {
        viewModel = DetailViewM.init(self)
        
        _tableview = viewModel.tableView
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview.sectionHeaderHeight = 0.01;
        
        //bottom comment btn
        _isScBtn = viewModel._isScBtn
        _commentNumber = viewModel._commentNumber
    }
    
    func getImages()  {
        let images = String.isNullOrEmpty(data["images"])
        if images.lengthOfBytes(using: String.Encoding.utf8) > 50 {
            let arr = images.components(separatedBy: ",")
            if arr.count > 0 {
                imgArr = imgArr + arr
            }
        }
  
    }
    
    ///可有子类重写获取不同的cell
    func getCell(_ tableView:UITableView , indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath);
        
        let _text = String.isNullOrEmpty(data["content"])
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = UIColor.black
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 30
        
        let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 17) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
        let attriStr = NSAttributedString.init(string: _text, attributes: dic)
        cell.textLabel?.attributedText = attriStr
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 +  lroundf(ceilf(Float(imgArr.count) / 3.0) ) // + pic 个数
        }else{
            //...没有评论或加载失败的处理
            return commentDataArr.count //评论数
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = getCell(tableView, indexPath: indexPath)
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
            let d = commentDataArr[indexPath.row]
            (cell as! HomeDetailCommentCell).fill(d)
            (cell as! HomeDetailCommentCell).avatarClickedAction = {[weak self] in
                guard let ss = self else {return}
                
                let vc = MeHomePageController.init(style:.plain)
                if let uid = d["uid"] as? String {
                    vc.uid = uid
                }
                
                ss.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil}
        guard let v = Bundle.main.loadNibNamed("HomeDetailFooterView", owner: nil, options: nil)?.last as? HomeDetailFooterView else{return nil}
        headFooterView = v
        
        if let readcnt = _readCnt {
            v.fill(readcnt)
        }
        
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? kSectionViewFooterHeight : 0.01
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
