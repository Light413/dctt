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
    var _bottomBar:UIToolbar!
    var _imgNumber:UILabel!
    
    var _toolBarIsHiden = false
    
    var dataArry = [PHAsset]()
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight);
        let _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)

        addTooBar()
        
        //
        _colloectionview.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
        
    }
    
    func addTooBar() {
        let _alpha:Float = 0.5
        _topBar = UIToolbar.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 60))
        _topBar.barStyle = .black
        _topBar.isTranslucent = true
        _topBar.setBackgroundImage(imageWithColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: _alpha)), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_topBar)
        _imgNumber = UILabel.init(frame: CGRect (x: (_topBar.frame.width - 120)/2, y: (_topBar.frame.height - 40)/2, width: 120, height: 40))
        _imgNumber.textAlignment = .center
        _imgNumber.textColor = UIColor.white
        _imgNumber.font = UIFont.systemFont(ofSize: 14)
        _topBar.addSubview(_imgNumber)
        _imgNumber.text = "已选择 1/9 张"
        
        
        let backbtn = UIButton (frame: CGRect (x: 20, y: 10 + (_topBar.frame.height - 60)/2, width: 40, height: 40))
        backbtn.setImage(UIImage (named: "photo_detail_titlebar_close"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        backbtn.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        _topBar.addSubview(backbtn)
        
        //bottomBar
        _bottomBar = UIToolbar.init(frame: CGRect (x: 0, y: kCurrentScreenHeight - 50, width: kCurrentScreenWidth, height: 60))
        _bottomBar.barStyle = .black
        _bottomBar.isTranslucent = true
        _bottomBar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        
        _bottomBar.setBackgroundImage(imageWithColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: _alpha)), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_bottomBar)
        
        let selectbtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 50, y: 0, width: 40, height: 40))
        selectbtn.setImage(UIImage (named: "ImgPic_select_preview-1"), for: .normal)
        selectbtn.setImage(UIImage (named: "ImgPic_select_ok_preview"), for: .selected)
        
        selectbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        selectbtn.addTarget(self, action: #selector(_selectImage(_:)), for: .touchUpInside)
        _bottomBar.addSubview(selectbtn)
        
        let okbutton = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        _bottomBar.addSubview(okbutton)
        okbutton.setTitle("完成", for: .normal)
        okbutton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        okbutton.setTitleColor(UIColor.white, for: .normal)
        okbutton.addTarget(self, action: #selector(finished), for: .touchUpInside)
    }
    
    
    //MARK: - EVENT
    func _dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func _selectImage(_ btn:UIButton) {
        btn.isSelected = !btn.isSelected
    }
    
    func finished()  {
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
        
        
        //collectionview.register(UINib (nibName: "TTImagePreviewCell", bundle: nil), forCellWithReuseIdentifier: "TTImagePreviewCellIdentifier")
        
        collectionview.register(TTImagePreviewCell2.self, forCellWithReuseIdentifier: "TTImagePreviewCellIdentifier")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTImagePreviewCellIdentifier", for: indexPath) as! TTImagePreviewCell2
        
        cell.setImage(dataArry[indexPath.row], type: .preview, isSelected: true)
        cell.imageClickedHandler = {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else {return}
                
                if !strongSelf._toolBarIsHiden {
                    strongSelf._topBar.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf._topBar.frame.height)
                    strongSelf._bottomBar.transform = CGAffineTransform.init(translationX: 0, y:strongSelf._bottomBar.frame.height)
                }else{
                    strongSelf._topBar.transform = CGAffineTransform.identity
                    strongSelf._bottomBar.transform = CGAffineTransform.identity
                }
            }) { [weak self] (finished) in
                guard let strongSelf = self else {return}
                strongSelf._toolBarIsHiden = !strongSelf._toolBarIsHiden
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if !self._toolBarIsHiden {
                self._topBar.transform = CGAffineTransform.init(translationX: 0, y: -50)
            }else{
                self._topBar.transform = CGAffineTransform.identity
            }
        }) { (finished) in
            self._toolBarIsHiden = !self._toolBarIsHiden
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
