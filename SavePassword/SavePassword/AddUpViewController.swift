//
//  AddUpViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/21.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class AddUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var sortID: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var urltxt: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortID.delegate = self
        tfTitle.delegate = self
        urltxt.delegate = self
        textView.delegate = self
        tfTitle.becomeFirstResponder()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == sortID {
            tfTitle.becomeFirstResponder()
        }else if textField == tfTitle {
            urltxt.becomeFirstResponder()
        }else if textField == urltxt {
            textView.becomeFirstResponder()
        }else{
            
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            // 延迟1毫米 执行
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC))/Double(1000*NSEC_PER_SEC) , execute: {
                self.textView.resignFirstResponder()
            })
          
        }
        
        return true
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    @IBAction func cancleAction(_ sender: Any) {
    }

    
    
}
