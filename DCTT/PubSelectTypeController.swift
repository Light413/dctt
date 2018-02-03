//
//  PubSelectTypeController.swift
//  DCTT
//
//  Created by wyg on 2018/2/1.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubSelectTypeController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    
    @IBOutlet weak var collectionview: UICollectionView!
   
    var dataArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0.8
        
        automaticallyAdjustsScrollViewInsets = false;
        
//        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
//        let _arr = NSArray.init(contentsOfFile: path!) as? [String]
//        if let arr = _arr {
//            dataArray = dataArray + arr;
//        }
        dataArray = dataArray + ["新鲜事","朋友圈","提问","商家信息","吃喝玩乐","相亲交友","求职招聘","房租租售","拼车出行","发布闲置"]
        // Do any additional setup after loading the view.
        _init()
        
        view.backgroundColor = UIColor.white
        
    }

    deinit {
        print("\(self.self) deinit")
    }

    func _init() {

        collectionview.delegate = self
        collectionview.dataSource = self
        
        let offset:CGFloat = 10
        let _width = (kCurrentScreenWidth - offset *  2 - 20) / 3.0
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: _width * 0.6)
        _layout.minimumInteritemSpacing = 2
        _layout.minimumLineSpacing = 15
        _layout.scrollDirection = .vertical
        
        collectionview.collectionViewLayout = _layout;
        
        //collectionview.register(UINib (nibName: "AllCategoryCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellIdentifier")
        
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.contentInset = UIEdgeInsetsMake(15, offset, 10, offset)
        
    }
    
    
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func _dismiss(completionHandler : ((Void) -> Void)? = nil) {
        HUD.show()
        
        self.dismiss(animated: false) {
            if let handler = completionHandler {
                handler();
                HUD.dismiss()
            }
        }

    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellIdentifier", for: indexPath)
        
        let str = dataArray[indexPath.row]
        
        for _v in cell.contentView.subviews{
            if _v is UILabel {
                _v.removeFromSuperview();
            }
        }
        
        let _t = UILabel (frame: CGRect (x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.contentView.addSubview(_t)
        _t.text = str
        _t.textAlignment = .center
        _t.font = UIFont.systemFont(ofSize: 15)
        //_t.textColor = UIColor.darkGray
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1).cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        

        _dismiss {
            var vc : UIViewController
            
            switch index {
            case 0: vc = PublishViewController(); break;
            case 1: vc = PublishFriendViewController(); break;
            default:return
            }
            
            let nav = BaseNavigationController (rootViewController:vc)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
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
