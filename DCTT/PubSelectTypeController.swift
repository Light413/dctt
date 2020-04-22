//
//  PubSelectTypeController.swift
//  DCTT
//
//  Created by wyg on 2018/2/1.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubSelectTypeController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    override var prefersStatusBarHidden: Bool {
        get{
            return false;
        }
    }
    
    
    @IBOutlet weak var collectionview: UICollectionView!
   
    var dataArray = [[[String:String]]]()
    let _head_section_titles = ["新动态","生活服务"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        let tv = UILabel (frame: CGRect (x: 0, y: 0, width: 100, height: 44))
        tv.text = "发布动态"
        tv.textAlignment = .center
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.darkGray
        navigationItem.titleView = tv
   
        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [[[String:String]]]
        if let arr = _arr {
            dataArray = dataArray + arr
        }
        
        // Do any additional setup after loading the view.
        _init()
        
        view.backgroundColor = UIColor.white
        
    }

    func _init() {

        collectionview.delegate = self
        collectionview.dataSource = self
        
        let offset:CGFloat = 30
        let _width = (kCurrentScreenWidth - offset *  2 - 15) / 2.0
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: _width * 0.5)
        _layout.minimumInteritemSpacing = 5
        _layout.minimumLineSpacing = 10
        _layout.scrollDirection = .vertical        
        collectionview.collectionViewLayout = _layout;
        
        
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellIdentifier")
        
        collectionview.register(UINib (nibName: "PubTypeCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PubTypeCollectionReusableViewIdentifier")
        
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.contentInset = UIEdgeInsets.init(top: 5, left: offset, bottom: 10, right: offset)
        
    }
    
    
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _dismiss(completionHandler : (() -> Void)? = nil) {
        HUD.show()
        
        self.dismiss(animated: false) {
            if let handler = completionHandler {
                handler();
                HUD.dismiss()
            }
        }

    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _head_section_titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellIdentifier", for: indexPath)
        
        let d = dataArray[indexPath.section][indexPath.row]
        let str = d["item_title"]
        
        for _v in cell.contentView.subviews{
            if _v is UILabel {
                _v.removeFromSuperview();
            }
        }
        
        let _t = UILabel (frame: CGRect (x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.contentView.addSubview(_t)
        _t.text = str
        _t.textAlignment = .center
        _t.font = UIFont.systemFont(ofSize: 15)
        _t.textColor = UIColorFromHex(rgbValue: 0x444444);
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = kTableviewBackgroundColor.cgColor
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _showAlert(indexPath);
    }
    
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let v = collectionview.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PubTypeCollectionReusableViewIdentifier", for: indexPath) as! PubTypeCollectionReusableView
            
            v.backgroundColor = UIColor.white
            v.title.text = _head_section_titles[indexPath.section]
            
            return v
        }
        
        return UICollectionReusableView()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize (width: collectionview.frame.width, height: section == 0 ? 50 : 50)
    }
    
    //MARK: - 
    func controllerWith(_ storyboarName:String = "Publish" , identifierId:String) -> UIViewController {
        let v = UIStoryboard.init(name: storyboarName, bundle: nil).instantiateViewController(withIdentifier: identifierId)
        
        return v
    }
    
    
    func _showAlert(_ indexPath: IndexPath) {
        let _v = UIAlertController.init(title: "提示", message: "请发布真实有效信息，否则审核无法通过。", preferredStyle: .alert);
        let action1 = UIAlertAction.init(title: "知道了", style: .default) {[weak self] (action)  in
            guard let ss = self else {return}
            ss._toPublish(indexPath);
        }
        let action2 = UIAlertAction.init(title: "发布须知", style: .default) {[weak self] (action)  in
            guard let ss = self else {return}
            let vc = BaseWebViewController(baseUrl:publish_note_url)
            vc.title = "发布须知"
            ss.navigationController?.pushViewController(vc, animated: true);
        }
        
        _v.addAction(action1);
        _v.addAction(action2);
        self.navigationController?.present(_v, animated: true, completion: nil);
    }
    
    func _toPublish(_ indexPath: IndexPath) {
        let d = dataArray[indexPath.section][indexPath.row]
        let item_id = d["item_id"]!
        
        _dismiss { [weak self]  in
            guard let strongSelf = self else {return }
            var vc : UIViewController
            
            switch item_id {
            case "id001" , "id004"://发布新鲜事
                if indexPath.section == 0 {
                    vc = PublishViewController.init(info:d)
                }else{
                    vc = strongSelf.controllerWith(identifierId: "pub_zt_id")
                }
                
                break;
                
                //            case "id002"://朋友圈
                //                vc = PublishFriendViewController(); break;
                
                //            case "id003"://房屋信息 - 问答
                //                vc =  //BaseVCWithTableView() //
                //                strongSelf.controllerWith(identifierId: "pub_fangwu_id")
                //                break
                
                //            case "id004"://商家信息
                //                vc = strongSelf.controllerWith(identifierId: "pub_shangjia_id")
                //                break
                
                //            case "id005"://交友
                //                vc = strongSelf.controllerWith(identifierId: "pub_jiaoyou_id")
                //                break
                
            case "id003" ,"id005" ,  "id006" , "id007"://求职招聘
                vc = strongSelf.controllerWith(identifierId: "pub_qiuzhi_id")
                break;
            default:return
            }
            
            if vc .isKind(of: PubBaseTableViewController.self){
                (vc as! PubBaseTableViewController).typeInfo = d
            }
            
            
            let nav = BaseNavigationController (rootViewController:vc)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PubSelectTypeController:ShowAlertControllerAble{}
