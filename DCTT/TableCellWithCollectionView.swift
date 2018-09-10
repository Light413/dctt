//
//  TableCellWithCollectionView.swift
//  DCTT
//
//  Created by wyg on 2018/9/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TableCellWithCollectionView: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let views = Bundle.main.loadNibNamed("TableCellWithCollectionView", owner: self, options: nil)
       
        if let v = views?.first as? UIView {
            self.addSubview(v)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PublishAddIconCellIdentifier")
        
        collectionView.reloadData()
    }
    

    func showImagePicker()  {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            HUD.showText("请在系统设置中允许访问相册", view: self)
            return
        }
        
        let vc = TTImagePickerViewController()
        //最大选择的数
        vc.maxImagesNumber = 9
        
        vc.imageSelectedCompletionHandler = {[weak self]  images in
            guard let strongSelf = self else {
                return
            }
            
//            strongSelf.imgDataArr = strongSelf.imgDataArr + images
//            strongSelf._colloectionview.reloadSections(IndexSet.init(integer: 1))
        }
        
       let  presentViewController = UINavigationController(rootViewController:vc)
        self.navigationController?.present(presentViewController, animated: true, completion: nil)
    }
    
}

extension TableCellWithCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublishAddIconCellIdentifier", for: indexPath)
        
        for _v in cell.contentView.subviews {
            _v.removeFromSuperview();
        }
        
        let igv = UIImageView (frame: CGRect (x: (cell.frame.width - 30)/2, y: (cell.frame.height - 30)/2, width: 30, height: 30))
        igv.image = UIImage (named: "addicon_repost")
        cell.contentView.addSubview(igv)
        cell.backgroundColor = UIColor (colorLiteralRed: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _w = (kCurrentScreenWidth - 10) / 3
        
        return CGSize (width: _w, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if true {
            let alertViewContronller = UIAlertController.init(title: "添加照片", message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
                guard let strongSelf = self else {return}
                strongSelf.showImagePicker()
            })
            
            let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { [weak self] (action) in
                guard let strongSelf = self else {return}
                //strongSelf.showCarema()
            })
            
            let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            
            alertViewContronller.addAction(action1)
            alertViewContronller.addAction(action2)
            alertViewContronller.addAction(action3)
            
            self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
        }
        
    }
}



