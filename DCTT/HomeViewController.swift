//
//  HomeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var vcArr = [BaseTableViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;
        
        for _ in 0..<5 {
            let v = BaseTableViewController();
            var ds = [String]()
            v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 49)
            
            for n in 0..<30 {
                ds.append("\(n + 1)")
            }
            v.dataArray = ds
            
            vcArr.append(v)
        }
        
        initSubview()
    }

    func createVc() -> UIViewController {
        let v = BaseTableViewController();
        var ds = [String]()
        v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 49)
        
        for n in 0..<30 {
            ds.append("\(n + 1)")
        }
        v.dataArray = ds

        return v
    }
    
    
    func initSubview() {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 49)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let _collectionview = UICollectionView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 49), collectionViewLayout: _layout)
        _collectionview.delegate  = self
        _collectionview.dataSource = self
        _collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String (describing: UICollectionViewCell.self))
        _collectionview.backgroundColor  = UIColor.white
        _collectionview.isPagingEnabled = true
        _collectionview.showsHorizontalScrollIndicator = false
        _collectionview.showsVerticalScrollIndicator = false
        
        view.addSubview(_collectionview)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: UICollectionViewCell.self), for: indexPath)

        let v = vcArr[indexPath.row]
        for _v in cell.subviews{
            _v.removeFromSuperview();
        }
        
        cell.addSubview(v.view)
        return cell
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
