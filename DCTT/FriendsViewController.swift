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

    var _dataArrayCnt = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        _init()

    }

    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 49);
        let _colloectionview = colleciontView(frame)
        _colloectionview.delegate = self
        _colloectionview.dataSource = self
        
        let header = TTRefreshHeader.init {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self._dataArrayCnt =  5
                            _colloectionview.reloadData()
                            _colloectionview.mj_header.endRefreshing()
                        }
        }
        
        _colloectionview.mj_header = header
        
        //_colloectionview.mj_header.beginRefreshing()
        
        let footer = TTRefreshFooter.init{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self._dataArrayCnt = self._dataArrayCnt + 5
                _colloectionview.reloadData()
                
                _colloectionview.mj_footer.endRefreshing()
            }

        }
        
        _colloectionview.mj_footer = footer
        
        view.addSubview(_colloectionview);

        t_barTintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = t_barTintColor
        
        _topHeadView()
    }
    
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: 160, height: 220)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "FriendsCollectonViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCollectonViewCellReuse")
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true

        return collectionview
    }
    
    func _topHeadView() {
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
        print("click")
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataArrayCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectonViewCellReuse", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FriendsDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.t_barTintColor = UIColor.white
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
