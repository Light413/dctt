//
//  TTPageViewController.swift
//  DCTT
//
//  Created by gener on 17/11/20.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
protocol TTPageViewControllerDelegate {
    func pageViewControllerScrollTo(_ index:Int)

}

class TTPageViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    var viewControllers :[UITableViewController]!
    var currentIndex: Int = 0//当前显示索引
    var delegate:TTPageViewControllerDelegate?    
    var _collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //automaticallyAdjustsScrollViewInsets = false
        _collectionView = self.colleciontView()
        view.addSubview(_collectionView)
    }



    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func colleciontView() -> UICollectionView {
        let rect = view.frame
        print(rect)
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = rect.size
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: rect, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String (describing: UICollectionViewCell.self))
        collectionview.backgroundColor  = UIColor.white
        collectionview.isPagingEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }
    
    func scrollToPageAtIndex(_ index:Int) {
        _collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .right, animated: true)
    }
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: UICollectionViewCell.self), for: indexPath)
        let v = viewControllers[indexPath.row]
        for _v in cell.contentView.subviews{
            _v.removeFromSuperview();
        }
        
        
        cell.contentView.addSubview(v.view)
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let i = lrintf(Float(index))
        guard i != currentIndex else{ return }
        currentIndex = i
        
        if let delegate = delegate {
            delegate.pageViewControllerScrollTo(i)
        }

    }
    


}
