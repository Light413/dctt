//
//  BaseDetailController.swift
//  DCTT
//
//  Created by wyg on 2018/1/26.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MJRefresh

class BaseDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    ///信息类别(首页详情， 生活服务详情，专题详情)
    var category:String!
    
    ///详情ID
    var pid:String!
    
    ///动态详情数据
    var data:[String:Any]!
    
    ///评论
    var commentDataArr = [[String:Any]]()
    var pageNumber:Int = 1;

    var _tableview:UITableView!

    var headView:HomeDetailHeadView!
    var headFooterView:HomeDetailFooterView!
    private let kSectionViewFooterHeight:CGFloat = 150
    private var _commentNumber:UILabel!
    private var _readCnt:[String:Any]?
    private var _isScBtn:UIButton! //是否收藏
    private var viewModel:DetailViewM!
    private var imgArr = [String]();
    private var loadCommentSuccess:Bool = true //标记评论加载成功
    
    ///是否是自己的发布
    var isMySelf:Bool = false
    
    ///设置评论数
    var commentNumbers:Int {
        get{return 0 }
        set{
            _commentNumber.isHidden = newValue == 0
            guard newValue > 0 else {return}

            let num:NSString = NSString.init(string: "\(newValue)")
            _commentNumber.text = String.init(num)
            
            let size = num.boundingRect(with: CGSize.init(width: 50, height: 10), options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):_commentNumber.font]), context: nil)
            _commentNumber.frame = CGRect (x: 30, y: 2, width: size.width + 10, height: 10)
        }
    }
    

    //MARK: - Load data
    //阅读量，点赞
    func loadReadCnt() {
        var d = ["pid":pid! ,
                 "type":"0",
                 //"uid":User.uid()!,
                 "category":category!
        ]
        
        if User.isLogined() {
            d["uid"] = User.uid()!
        }
        
        AlamofireHelper.post(url: post_detail_url, parameters: d, successHandler: {[weak self] (res) in
            guard var body = res["body"] as? [String:Any] else {return}
            guard let ss = self else {return}
            if let footview = ss.headFooterView {
                body["content"] = String.isNullOrEmpty(ss.data["content"])
                body["isMySelf"] = ss.isMySelf ? "1" : "0"
                body["pid"] = ss.pid!
                body["category"] = ss.category!

              footview.fill(body)
            }
            
            ss._readCnt = body
            
            //是否收藏
            ss._isScBtn.isSelected = String.isNullOrEmpty(body["sc"]) == "1"
            
        }) { (error) in
            print(error?.localizedDescription)
        }
        
    }
    
    ///获取评论
    func loadComment() {
        let d = ["type":"get",
                 "pid":pid!,
                 "category":category!,
                 "pageNumber":pageNumber
            ] as [String : Any]
        
        AlamofireHelper.post(url: comment_url, parameters: d, successHandler: {[weak self] (res) in
            guard let arr = res["body"] as? [[String:Any]] else {return}
            guard let ss = self else {return}
            ss.loadCommentSuccess = true
            
            if ss.pageNumber == 1 { ss.commentDataArr.removeAll();}
            if ss._tableview.mj_header.isRefreshing(){ss._tableview.mj_header.endRefreshing()}
            else if ss._tableview.mj_footer.isRefreshing() {ss._tableview.mj_footer.endRefreshing()}
            
            if ss._tableview.mj_footer.isHidden && arr.count > 0 {ss._tableview.mj_footer.isHidden = false}
            
            ss.commentDataArr = ss.commentDataArr + arr
            ss.commentNumbers = ss.commentDataArr.count;
            if arr.count < 20 { ss._tableview.mj_footer.state = .noMoreData}
            
            //刷新列表
            UIView.performWithoutAnimation {
                ss._tableview.reloadSections([1], with: .none)
            }
        }) { [weak self](err) in
            guard let ss = self else {return}
            ss.loadCommentSuccess = false
            
            if ss._tableview.mj_header.isRefreshing(){ss._tableview.mj_header.endRefreshing()}
            else if ss._tableview.mj_footer.isRefreshing() {ss._tableview.mj_footer.endRefreshing()}
            
            UIView.performWithoutAnimation {
                ss._tableview.reloadSections([1], with: .none)
                
            }
            HUD.show(info: "获取评论失败,请稍后重试")
            print(err?.localizedDescription);
        }
        
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        let author_id = String.isNullOrEmpty(data["uid"])
        if let uid = User.uid(){
            isMySelf = author_id == uid//是本人吗
        }
        
        
//        if isMySelf {
            addRightNavigationItem()
//        }
        
        initSubview()
        
        loadReadCnt()
        
        getImages()

        
        ///删除评论通知
        NotificationCenter.default.addObserver(self, selector: #selector(refreshComment), name: kDeleteCommentNotification, object: nil)
    }

    @objc func refreshComment()  {
        pageNumber = 1
        
        loadComment()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(_ _id:String , type _category:String) {
        super.init(nibName: nil, bundle: nil)
        pid = _id
        category = _category
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview()  {
        viewModel = DetailViewM.init(self)
        viewModel.category = category
        viewModel.type = String.isNullOrEmpty(data["type"])
        
        _tableview = viewModel.tableView
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview.sectionHeaderHeight = 0.01;
        
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = 1
            strongSelf._tableview.mj_footer.state = .idle
            strongSelf.loadComment()
        })
        
        _tableview.mj_header = header;
        
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = strongSelf.pageNumber + 1
            strongSelf.loadComment();
        }
        
        _tableview.mj_footer = footer
        _tableview.mj_footer.isHidden = true
        
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
        
        let dic:[String:Any] = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 17) , convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1]
        let attriStr = NSAttributedString.init(string: _text, attributes: convertToOptionalNSAttributedStringKeyDictionary(dic))
        cell.textLabel?.attributedText = attriStr
        
        return cell
    }
    
    //MARK: - Action
    
    ///举报别人的帖子，删除自己的帖子
    override func _rightItemAction()  {
//        guard User.isLogined() else {
//            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
//            return
//        }
        
        let isme = isMySelf//是本人吗
        
        
        let alertViewContronller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction.init(title: "举报", style: .default, handler: {[weak self] (action) in
            guard let ss = self else {return}
            ss._jubao()
        })

        alertViewContronller.addAction(action1)
        
        if isme {
            let action2 = UIAlertAction.init(title: "删除", style: .default, handler: {[weak self] (action) in
                
                Tools.showMsg("确定要删除这条动态?", title: "确定", handler: { () in
                    guard let ss = self else {return}
                    ss._deleteMYPost()

                })
            })
            
            alertViewContronller.addAction(action2)
        }

        
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertViewContronller.addAction(action3)
        
        self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
    }
    
    
    ///举报该动态
    func _jubao() {
        let v = UIStoryboard.init(name: "me", bundle: nil).instantiateViewController(withIdentifier: "jubao_id") as! JuBaoController
        v.postId = ["pid":String.isNullOrEmpty(pid!),
                    "category":String.isNullOrEmpty(category!)
        ]
        
        
        let nav = BaseNavigationController(rootViewController: v)
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        
        
        
        /*guard let myid = User.uid() else {return}
        let d = ["uid":myid ,
                 "pid": pid!,
                 "category":category!,
                 ] as [String : Any]
        
        HUD.show()

        AlamofireHelper.post(url: jubao_url, parameters: d, successHandler: { (res) in
            guard let msg = res["msg"] as? String else {HUD.dismiss(); return}
            HUD.show(successInfo: msg)
        }) { (err) in
            HUD.show(info: (err?.localizedDescription)!)
        }*/

    }
    
    ///删除我的动态 9dc0d0bf078855d42e5391ee422056f4
    func _deleteMYPost() {
        guard let myid = User.uid() else {return}
        let d = ["uid":myid ,
                 "pid": pid!,
                 "category":category!,
                 "type":0] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: delete_sc_url, parameters: d, successHandler: {[weak self] (res) in
            print(res)
            
            HUD.show(successInfo: "删除成功")
            guard let ss = self else {return}
            ss.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            HUD.show(info: "删除失败,请重试")
        }

    }
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 +  lroundf(ceilf(Float(imgArr.count) / 3.0) ) // + pic 个数
        }else{
            //没有评论或加载失败
            if commentDataArr.count == 0 {
                return 1
            }
            
            return loadCommentSuccess ?  commentDataArr.count : commentDataArr.count + 1//评论数
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
            if commentDataArr.count == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
                cell.textLabel?.text = loadCommentSuccess ? "暂无评论" : "加载评论失败,点击重试"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.textLabel?.textColor = UIColor.lightGray
                cell.textLabel?.textAlignment = .center
            }
            else
            {
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
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil}
        guard let v = Bundle.main.loadNibNamed("HomeDetailFooterView", owner: nil, options: nil)?.last as? HomeDetailFooterView else{return nil}
        v.category = category
        
        headFooterView = v
        
        if var readcnt = _readCnt {
            readcnt["content"] = String.isNullOrEmpty(data["content"])
            readcnt["isMySelf"] = isMySelf ? "1" : "0"
            readcnt["pid"] = pid!
            readcnt["category"] = category!
            
            v.fill(readcnt)
        }
        
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? kSectionViewFooterHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard commentDataArr.count == 0 else {return}
        guard !loadCommentSuccess else {return}
        loadComment()
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
