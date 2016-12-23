//
//  AddViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/21.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CloudKit

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

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
        
        self.title = NSLocalizedString("Add", comment: "")
        
        textView.text = "Account: \n\nPassword:"
        
        // 加监听
        NotificationCenter.default.addObserver(self, selector: #selector(tvBegin), name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tvEnd), name: .UITextViewTextDidEndEditing, object: nil)
        
        // init data
        urltxt.text = "www."
        initSortID()
    }
    
    func initSortID() {
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
        var id:String = sortID.text!
        var title:String = tfTitle.text!
        var url:String = urltxt.text!
        let spData:String = textView.text!
        
        id = id.trimmingCharacters(in: .whitespaces)
        title = title.trimmingCharacters(in: .whitespaces)
        url = url.trimmingCharacters(in: .whitespaces)
        
        // id 是否为空
        if id == "" {
            self.view.makeToast(NSLocalizedString("IDnot", comment: ""), duration: 3.0, position: .center)
            initSortID()
            return
        }
        let iID = Int64(id)
        if iID == nil {
            self.view.makeToast(NSLocalizedString("IDnot", comment: ""), duration: 3.0, position: .center)
            initSortID()
            return
        }
        // id是否重复
        for i in 0..<arrData.count {
            let getID = arrData[i].value(forKey: "ID")
            let igetID:Int64 = getID as! Int64
            if iID == igetID {
                self.view.makeToast(NSLocalizedString("IDre", comment: ""), duration: 3.0, position: .center)
                return
            }
        }
        
        let one = CKRecord(recordType: "SavePassword")
        one["ID"] = iID as CKRecordValue?
        one["title"] = title as CKRecordValue?
        one["url"] = url as CKRecordValue?
        one["spdata"] = spData as CKRecordValue?
        CKContainer.default().publicCloudDatabase.save(one) { (record:CKRecord?, err:Error?) in
            if err == nil {
                print("save sucess")
                // 保存成功
                DispatchQueue.main.async {
                    arrData.append(one)
                    self.view.makeToast(NSLocalizedString("savesucess", comment: ""), duration: 3.0, position: .center)
                    self.navigationController!.popViewController(animated: true)
                }
            }else {
                // 保存不成功
                print("save fail")
            }
        }
    }
    
    // 取消
    @IBAction func cancleAction(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }

    
    
}
