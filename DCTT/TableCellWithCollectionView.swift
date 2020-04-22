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
    
    ///所属的主UIViewController
    weak var superVC:UIViewController?
    
    ///选择的图片
    var imagesArr = [Any]()
    var imagePicker :TTImagePicker!

    override func layoutSubviews() {
        
        imagePicker.viewController = superVC
        collectionView.frame = self.frame
        
        self.updateConstraintsIfNeeded()
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
        collectionView.register(UINib (nibName: "PublishImageCell", bundle: nil), forCellWithReuseIdentifier: "PublishImageCellIdentifier")
        

        
        collectionView.reloadData()

        //
        imagePicker = TTImagePicker()
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectImageNoti(_ :)), name: imagePicker.selectedCompletionNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("TableCellWithCollectionView:deinit")
    }

    @objc func selectImageNoti(_ noti:Notification)  {
        print("selectedCompletionNotificationName")
        
        if let u = noti.userInfo!["images"] as? [Any]{
            imagesArr = imagesArr + u
            
            collectionView.reloadData()
        }
        
    }
}

extension TableCellWithCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  imagesArr.count + 1 > 9 ? 9 : imagesArr.count + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexPath.row < imagesArr.count ? "PublishImageCellIdentifier" :"PublishAddIconCellIdentifier", for: indexPath)
            
        
            if indexPath.row < imagesArr.count {
                let cell = cell as! PublishImageCell
                cell.cellSelectedHandler = {[weak self] b -> Bool in
                    guard let strongSelf = self else {return false}
                    strongSelf.imagesArr.remove(at: indexPath.row)
                    strongSelf.collectionView.reloadData()
                    return true
                }
                
                let asset = imagesArr[indexPath.row]
                cell.setImage(asset, type: .publish)
                cell.backgroundColor = UIColor.white;
            }else{
                for _v in cell.contentView.subviews {
                    _v.removeFromSuperview();
                }
                
                let igv = UIImageView (frame: CGRect (x: (cell.frame.width - 30)/2, y: (cell.frame.height - 30)/2, width: 30, height: 30))
                igv.image = UIImage (named: "addicon_repost")
                cell.contentView.addSubview(igv)
                cell.backgroundColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1) 
            }
        

        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _w = (collectionView.frame.width - 30) / 3
        
        return CGSize (width: _w, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imagesArr.count == indexPath.row {
            imagePicker.maxImageNumber = 9 - imagesArr.count
            
            imagePicker.show();
        }
        
    }
}




