//
//  PubWriteCell.swift
//  DCTT
//
//  Created by wyg on 2018/1/28.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubWriteCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var write_tf: UITextField!
    
    var tv:UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        write_tf.tintColor = UIColor.clear
        
        tv = UITextView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 100))
        write_tf.inputAccessoryView = tv
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    @objc func keyboardAppear()  {
        tv.becomeFirstResponder()
    }
    
    
    //MARK: - 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print(textField.text)
        return true
    }
    
    @IBAction func writeBtnAction(_ sender: Any) {
        write_tf.becomeFirstResponder()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
