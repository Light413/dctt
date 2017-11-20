//
//  TTHeadTitleView.swift
//  DCTT
//
//  Created by gener on 17/11/20.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

protocol TTHeadTitleClickDelegate {
    func titleClickedAtIndex(_ index:Int);

}


class TTHeadTitleView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var  titles :[String]!
    var currentIndex: Int = 0//当前显示索引
    var _collectionView:UICollectionView!
    var delegate:TTHeadTitleClickDelegate?
    
    private let _item_width:CGFloat = 50
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        _collectionView = colleciontView(frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height - 1))
        self.addSubview(_collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func colleciontView(frame:CGRect) -> UICollectionView {
        print(frame)
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _item_width, height: frame.height)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String (describing: UICollectionViewCell.self))
        collectionview.backgroundColor  = UIColor.white
        collectionview.isPagingEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundView = nil
        collectionview.backgroundColor = UIColor.white
        collectionview.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        return collectionview
    }
    
    func scrollToPageAtIndex(_ index:Int) {
        currentIndex = index
        _collectionView.reloadData()
    }

    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: UICollectionViewCell.self), for: indexPath)
        let v = titles[indexPath.row]
        
        for _v in cell.contentView.subviews{
            _v.removeFromSuperview();
        }
        let l = UILabel.init(frame: CGRect (x: 0, y: 0, width: _item_width, height: self.frame.height))
        l.font = UIFont.systemFont(ofSize: currentIndex == indexPath.row ? 17:16)
        l.textAlignment = .center
        l.text = v
        l.textColor = currentIndex == indexPath.row ? UIColor.red:UIColor.black
        
        cell.contentView.addSubview(l)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        guard index != currentIndex else{ return }
        currentIndex = index
        collectionView.reloadData()
        
        //delegate
        if let delegate = delegate {
            delegate.titleClickedAtIndex(index)
        }
    }

    
    
}
