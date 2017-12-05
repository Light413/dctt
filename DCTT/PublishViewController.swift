//
//  PublishViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class PublishViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        addNavigationItem()
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64);
        let _colloectionview = colleciontView(frame)
        
        view.addSubview(_colloectionview)
    }

    
    func addNavigationItem() {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        leftbtn.setTitle("取消", for: .normal)
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        navigationItem.leftBarButtonItem = leftitem
        
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("发布", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray, for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        navigationItem.rightBarButtonItem = rightitem

    }
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: 10, height: 10)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 10
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "PublishTextCell", bundle: nil), forCellWithReuseIdentifier: "PublishTextCellIdentifier")
        collectionview.register(UINib (nibName: "PublishImageCell", bundle: nil), forCellWithReuseIdentifier: "PublishImageCellIdentifier")
        
        collectionview.register(UINib (nibName: "", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "")
        
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionview.alwaysBounceVertical = true
        
        return collectionview
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1:6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (indexPath.section == 0) ? "PublishTextCellIdentifier":"PublishImageCellIdentifier"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            
        }
        
    }
    
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: 300, height: 120)
        }
        
        return CGSize (width: 90, height: 120)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
