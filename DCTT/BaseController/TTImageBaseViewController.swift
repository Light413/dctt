//
//  TTImageBaseViewController.swift
//  DCTT
//
//  Created by gener on 2017/12/8.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class TTImageBaseViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionview:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionview = UICollectionView()
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.alwaysBounceVertical = true
        
        view.addSubview(collectionview)
        
        initCollectoinView()
    }

    //MARK: -需要子类实现的方法
    func initCollectoinView() { }
    
    func numberOfSections() -> Int { return  1 }
    
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath);
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
