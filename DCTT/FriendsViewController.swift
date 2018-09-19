//
//  FriendsViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import MJRefresh

class FriendsViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var dataArray = [[String:Any]]();
    var pageNumber:Int = 1;
    
    var _colloectionview:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //automaticallyAdjustsScrollViewInsets = false
        _init()

        HUD.show(withStatus: "数据加载中")
        loadData()
    }

    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 50);
        _colloectionview = colleciontView(frame)
        _colloectionview.delegate = self
        _colloectionview.dataSource = self
        
        let header = TTRefreshHeader.init {[weak self] in
            guard let ss = self else {return}
            
            ss.loadData()
        }
        
        _colloectionview.mj_header = header
        
        //_colloectionview.mj_header.beginRefreshing()
        
        let footer = TTRefreshFooter.init{

        }
        
        _colloectionview.mj_footer = footer
        
        view.addSubview(_colloectionview);

        //_topHeadView()
    }
    
    func loadData() {

        var subType = 0
        
        let d = ["category":"friend" , "subType":subType] as [String : Any]
        
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            
            if ss._colloectionview.mj_header.isRefreshing(){
                ss._colloectionview.mj_header.endRefreshing()
            }else if ss._colloectionview.mj_footer.isRefreshing() {
                ss._colloectionview.mj_footer.endRefreshing()
            }
            
            if let arr = res["body"] as? [[String:Any]] {
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss._colloectionview.mj_footer.state = .noMoreData
                }else{
                    ss._colloectionview.mj_footer.isHidden = false
                }
            }else {
                ss._colloectionview.mj_footer.state = .noMoreData
            }
            
            
            ss._colloectionview.reloadData()
            //print(res);
        }) { (error) in
            HUD.dismiss()
        }
        
        
    }
    
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        let _w = (kCurrentScreenWidth - 0) / 1.0
        
        _layout.itemSize = CGSize (width: _w, height: _w * 0.8)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 5
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "ZTCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCollectonViewCellReuse")
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        //collectionview.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
        return collectionview
    }
    
    /*func _topHeadView() {
        let segment = UISegmentedControl.init(items: ["最新","人气"])
        segment.frame = CGRect (x: 0, y: 0, width: 180, height: 25)
        segment.tintColor = tt_BarColor
        segment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkGray], for: .normal)
        segment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .selected)
        
        segment.selectedSegmentIndex = 0
        navigationItem.titleView = segment
        
        //seaerch button
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "search_subscibe_titilebar"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backbtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: backbtn)
        navigationItem.rightBarButtonItem = leftitem
    }
    
    func searchAction() {
    }*/
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectonViewCellReuse", for: indexPath) as! ZTCollectionViewCell
//        let d = dataArray[indexPath.row]
//        cell.fill(d)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let vc = FriendsDetailController(pid,type:"----")
        
        vc.data = d
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
