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
    var keyHeight = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortID.delegate = self
        tfTitle.delegate = self
        urltxt.delegate = self
        textView.delegate = self
        tfTitle.becomeFirstResponder()
        
        textView.text = "Account: \n\nPassword:"
        
        // 加监听
        NotificationCenter.default.addObserver(self, selector: #selector(tvBegin), name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tvEnd), name: .UITextViewTextDidEndEditing, object: nil)
        
        // init data
        urltxt.text = "www."
        if arrData.count == 0 {
            sortID.text = String(100)
        }else {
            let lastID:Int64 = arrData[arrData.count-1]["ID"] as! Int64
            sortID.text = String( lastID + 100)
        }
    }
    
    
    func tvBegin() {
//        print("text view begin")
    }
    
    func tvEnd() {
//        print("text view end")
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
            // 延迟1毫秒 执行
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC))/Double(1000*NSEC_PER_SEC) , execute: {
                self.textView.resignFirstResponder()
            })
          
        }
        
        return true
    }
    
    
    // 保存数据
    @IBAction func saveAction(_ sender: Any) {
        let id:String = sortID.text!
        let title:String = tfTitle.text!
        let url:String = urltxt.text!
        let spData:String = textView.text!

        let aa:String = NSLocalizedString("teststr", comment: "")
        print(aa)
        
        
        let tips1 = NSLocalizedString("IDnot", comment: "")
        print(tips1)
        print(NSLocalizedString("HIOK", comment: ""))
        print(NSLocalizedString("idnotempty", comment: ""))
        // id 是否为空
//        if id == "" {
            self.view.makeToast(NSLocalizedString("IDnot", comment: ""), duration: 3.0, position: .center)
//        }
    }
    
    // 取消
    @IBAction func cancleAction(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }

    
    
}
