//
//  AllViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class AllViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        _init()
    }
    
    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 49);
        let _colloectionview = colleciontView(frame)
        _colloectionview.delegate = self
        _colloectionview.dataSource = self
        view.addSubview(_colloectionview);
        
        t_barTintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = t_barTintColor
//        
//        _topHeadView()
    }
    

    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: 100, height: 100)
        _layout.minimumInteritemSpacing = 5
        _layout.minimumLineSpacing = 5
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "AllCategoryCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        
        return collectionview
    }
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCellReuseIdentifierId", for: indexPath)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
