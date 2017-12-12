//
//  TTImagePreviewController.swift
//  DCTT
//
//  Created by gener on 2017/12/8.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    var _topBar:UIToolbar!
    var _topBarIsHiden = false
    
    var dataArry = [PHAsset]()
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight);
        let _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)

        _topBar = UIToolbar.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        _topBar.barStyle = .black
        _topBar.isTranslucent = true
        _topBar.setBackgroundImage(imageWithColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.01)), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_topBar)
        
        let backbtn = UIButton (frame: CGRect (x: 15, y: 5, width: 40, height: 40))
        backbtn.setImage(UIImage (named: "photo_detail_titlebar_close"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        backbtn.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        _topBar.addSubview(backbtn)
        
        //
        _colloectionview.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
        
    }
    
    func _dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func imageWithColor(_ color:UIColor) -> UIImage? {
        let rect = CGRect (x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(color.cgColor)
        
        ctx?.fill(rect)
        
        let ig = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return ig
    
    }
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()

        _layout.itemSize = frame.size
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        
        
        collectionview.register(UINib (nibName: "TTImagePreviewCell", bundle: nil), forCellWithReuseIdentifier: "TTImagePreviewCellIdentifier")
        
        collectionview.backgroundColor  = UIColor.black
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.alwaysBounceVertical = false
        
        collectionview.isPagingEnabled = true
        
        return collectionview
    }
    
    func addNavigationItem() {
        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        _topBg.backgroundColor = tt_defafault_barColor
        view.addSubview(_topBg)
        
        let leftbtn = UIButton (frame: CGRect (x: 15, y: 10, width: 35, height: 35))
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)
        
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)

        _topBg.addSubview(leftbtn)
        
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArry.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTImagePreviewCellIdentifier", for: indexPath) as! TTImagePreviewCell
        
        cell.setImage(dataArry[indexPath.row], type: .preview, isSelected: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if !self._topBarIsHiden {
                self._topBar.transform = CGAffineTransform.init(translationX: 0, y: -50)
            }else{
                self._topBar.transform = CGAffineTransform.identity
            }
        }) { (finished) in
            self._topBarIsHiden = !self._topBarIsHiden
        }
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
