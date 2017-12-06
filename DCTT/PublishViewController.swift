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
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 0);
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
        rightbtn.setTitleColor(kAirplaneCell_head_selected_color, for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        navigationItem.rightBarButtonItem = rightitem

    }
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: 10, height: 10)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 5
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "PublishTextCell", bundle: nil), forCellWithReuseIdentifier: "PublishTextCellIdentifier")
        collectionview.register(UINib (nibName: "PublishImageCell", bundle: nil), forCellWithReuseIdentifier: "PublishImageCellIdentifier")
        
        collectionview.register(UINib (nibName: "PublishCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "PublishCollectionReusableViewIdentifier")
        collectionview.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String (describing: UICollectionReusableView.self))
        
        collectionview.backgroundColor  = UIColor.white

        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.alwaysBounceVertical = true
        
        return collectionview
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:return 6;
        case 2:return 0;
        default:return 0;
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (indexPath.section == 0) ? "PublishTextCellIdentifier":"PublishImageCellIdentifier"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = PublishViewController();
//        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let identifier = indexPath.section < 2 ? String (describing: UICollectionReusableView.self):"PublishCollectionReusableViewIdentifier"
            
            let _v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
            
            var _c:UIColor!
            switch indexPath.section {
                case 0:_c = UIColor.white;break
                case 1:_c = kTableviewBackgroundColor;break
                case 2:_c = UIColor.white;break

                default:break
            }
            
            _v.backgroundColor = _c
            
            return _v
        
        }
        
        let v = UICollectionReusableView()
        v.backgroundColor = UIColor.white
        
        return v
    }
    
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: kCurrentScreenWidth - 20, height: 100)
        }
        
        let _w = (kCurrentScreenWidth - 20 - 10) / 3
        
        return CGSize (width: _w, height: 100)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize (width: collectionView.frame.width, height: section > 1 ? 50:(section == 0 ? 0:10))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section < 2 {
            return UIEdgeInsetsMake(5, 10, 5, 10)
        }
        
        return UIEdgeInsets.zero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
