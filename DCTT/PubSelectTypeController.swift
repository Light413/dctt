//
//  PubSelectTypeController.swift
//  DCTT
//
//  Created by wyg on 2018/2/1.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubSelectTypeController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    
    @IBOutlet weak var collectionview: UICollectionView!
   
    var dataArray = [[[String:String]]]()
    let _head_section_titles = ["发布新动态","发布生活服务"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.alpha = 0.8
        automaticallyAdjustsScrollViewInsets = false;
        
        //let dt = ["新鲜事","朋友圈","提问","吐槽","搞笑段子","校园"]
        //dataArray.append(dt)
        
        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [[[String:String]]]
        if let arr = _arr {
            dataArray = dataArray + arr
        }
        
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
        let _width = (kCurrentScreenWidth - offset *  2 - 10) / 3.0
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: 50)
        _layout.minimumInteritemSpacing = 2
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .vertical        
        collectionview.collectionViewLayout = _layout;
        
        
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellIdentifier")
        
        collectionview.register(UINib (nibName: "PubTypeCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PubTypeCollectionReusableViewIdentifier")
        
        collectionview.showsHorizontalScrollIndicator = false
        //collectionview.showsVerticalScrollIndicator = false
        collectionview.contentInset = UIEdgeInsetsMake(5, offset, 10, offset)
        
//        collectionview.layer.borderWidth = 2
//        collectionview.layer.borderColor = kTableviewBackgroundColor.cgColor //UIColor.lightGray.cgColor
//        collectionview.layer.cornerRadius = 5
//        collectionview.layer.masksToBounds = true
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _head_section_titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellIdentifier", for: indexPath)
        
        let d = dataArray[indexPath.section][indexPath.row]
        let str = d["item_title"]
        
        for _v in cell.contentView.subviews{
            if _v is UILabel {
                _v.removeFromSuperview();
            }
        }
        
        let _t = UILabel (frame: CGRect (x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.contentView.addSubview(_t)
        _t.text = str
        _t.textAlignment = .center
        _t.font = UIFont.systemFont(ofSize: 13)
        //_t.textColor = UIColor.darkGray
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor (red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1).cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let d = dataArray[indexPath.section][indexPath.row]
        let item_id = d["item_id"]!
        

        _dismiss {
            var vc : UIViewController
            
            switch item_id {
            case "id001"://发布新鲜事
                vc = PublishViewController(); break;
                
            case "id002"://朋友圈
                vc = PublishFriendViewController(); break;
                
            case "id003"://问答
                vc =  //BaseVCWithTableView() //
                self.controllerWith(identifierId: "pub_question_id")
                break
                
            case "id004"://商家信息
                
                return; break
                
            case "id005"://交友
                
                return; break
                
            case "id006"://求职招聘
                
                return; break
                
            case "id007"://打车出行
                
                return; break
                
            case "id008"://快递物流
                
                return; break
                
            default:return
            }
            
            let nav = BaseNavigationController (rootViewController:vc)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let v = collectionview.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PubTypeCollectionReusableViewIdentifier", for: indexPath) as! PubTypeCollectionReusableView
            
            v.backgroundColor = UIColor.white
            v.title.text = _head_section_titles[indexPath.section]
            
            return v
        }
        
        return UICollectionReusableView()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize (width: collectionview.frame.width, height: section == 0 ? 50 : 50)
    }
    
    //MARK: - 
    func controllerWith(_ storyboarName:String = "Publish" , identifierId:String) -> UIViewController {
        let v = UIStoryboard.init(name: storyboarName, bundle: nil).instantiateViewController(withIdentifier: identifierId)
        
        return v
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
