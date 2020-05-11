//
//  HomeDetailImgCell3.swift
//  DCTT
//
//  Created by wyg on 2018/8/13.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailImgCell3: UITableViewCell {

    @IBOutlet weak var img_h: NSLayoutConstraint!
    
    var tapActionHandler:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let _w = kCurrentScreenWidth / 3.0 - 10
        img_h.constant = 1.2 * _w
        
        for i in 1...3{
            if let igv = self.contentView.viewWithTag(i) as? UIImageView {
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :)))
                
                igv.addGestureRecognizer(tap)
            }
        }

    }
    
    @objc func tapAction(_ tap:UITapGestureRecognizer)  {
        guard let tag = tap.view?.tag else {return}
        guard let handler = tapActionHandler else { return}
        handler(tag)
    }
    
    override func prepareForReuse() {
        for i in 1...3{
            if let igv = self.contentView.viewWithTag(i) as? UIImageView {
                igv.isUserInteractionEnabled = false;
            }
        }

    }

    func fill(_ arr:[String]) {
        for i in 1...arr.count {
            let s = arr[i - 1]
            let url = URL.init(string: s)
            if let igv = self.contentView.viewWithTag(i) as? UIImageView {
                igv.isUserInteractionEnabled = true;
                igv.kf.setImage(with: url, placeholder: UIImage (named: "default_image2"))
            }
        }
    }
    
    
}
