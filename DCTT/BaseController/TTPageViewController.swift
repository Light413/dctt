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
    var _viewControllers :[UITableViewController]!
    var currentIndex: Int = 0//当前显示索引
    var _delegate:TTPageViewControllerDelegate?    
    var _collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }


    init(controllers:[UITableViewController], frame viewFrame:CGRect,delegate:TTPageViewControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        _viewControllers = controllers
        _delegate = delegate
        view.frame = viewFrame
        
        _collectionView = self.colleciontView()
        view.addSubview(_collectionView)
        
        for vc in controllers {
            self.addChildViewController(vc)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func colleciontView() -> UICollectionView {
        let rect = CGRect (x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
        _collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .right, animated: false)
    }
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: UICollectionViewCell.self), for: indexPath)
        let v = _viewControllers[indexPath.row]
        for _v in cell.contentView.subviews{
            _v.removeFromSuperview();
        }
        
        
        cell.contentView.addSubview(v.view)
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        _scroll(scrollView);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _scroll(scrollView);
    }

    func _scroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let i = lrintf(Float(index))
        guard i != currentIndex else{ return }
        currentIndex = i
        
        if let delegate = _delegate {
            delegate.pageViewControllerScrollTo(i)
        }
    }
    
    
    
}
