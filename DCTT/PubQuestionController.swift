//
//  PubQuestionController.swift
//  DCTT
//  发布提问-可添加附件图片
//  Created by wyg on 2018/3/2.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubQuestionController: PubBaseTableViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuseIdentifier")
    }

    
    //MARK: 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellReuseIdentifier", for: indexPath)
        
        for _v in cell.contentView.subviews {
            _v.removeFromSuperview();
        }
        
        let igv = UIImageView (frame: CGRect (x: (cell.frame.width - 30)/2, y: (cell.frame.height - 30)/2, width: 30, height: 30))
        igv.image = UIImage (named: "addicon_repost")
        cell.contentView.addSubview(igv)
        cell.backgroundColor = UIColor (colorLiteralRed: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        
        return cell
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
