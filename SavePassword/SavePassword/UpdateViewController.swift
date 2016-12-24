//
//  UpdateViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CloudKit

class UpdateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var localCancle: UIButton!
    @IBOutlet weak var localSave: UIButton!
    @IBOutlet weak var localNote: UILabel!
    @IBOutlet weak var localURL: UILabel!
    @IBOutlet weak var localTitle: UILabel!
    
    @IBOutlet weak var sortID: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var urltxt: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lastUpdateTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sortID.delegate = self
        tfTitle.delegate = self
        urltxt.delegate = self
        textView.delegate = self
        textView.becomeFirstResponder()
        
        self.title = NSLocalizedString("Update", comment: "")

        // init data
        urltxt.text = ""
        initSpData()
        initLocalize()
    }
    
    func initSpData() {
        let one = arrData[gIndex]
        
        let iID:Int64 = (one.value(forKey: "ID") as! Int64?)!
        sortID.text = String(iID)
        tfTitle.text = one.value(forKey: "title") as! String?
        urltxt.text = one.value(forKey: "url") as! String?
        textView.text = one.value(forKey: "spdata") as! String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let update:String = dateFormatter.string(from: one.modificationDate!)
        lastUpdateTime.text = update
    }
    
    func initLocalize() {
        localTitle.text = NSLocalizedString("Title", comment: "") + ":"
        localURL.text = NSLocalizedString("URL", comment: "") + ":"
        localNote.text = NSLocalizedString("Note", comment: "")
        
        localCancle.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        localSave.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        
        sortID.placeholder = NSLocalizedString("Enter Sort ID", comment: "")
        tfTitle.placeholder = NSLocalizedString("Enter Title", comment: "")
        urltxt.placeholder = NSLocalizedString("Enter URL", comment: "")
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
            return
        }
        let iID = Int64(id)
        if iID == nil {
            self.view.makeToast(NSLocalizedString("IDnot", comment: ""), duration: 3.0, position: .center)
            return
        }
        // id是否重复
        var icount = 0
        for i in 0..<arrData.count {
            let getID = arrData[i].value(forKey: "ID")
            let igetID:Int64 = getID as! Int64
            if iID == igetID {
                icount += 1
            }
        }
        if icount > 1 {
            self.view.makeToast(NSLocalizedString("IDre", comment: ""), duration: 3.0, position: .center)
            return
        }
        
        self.view.isUserInteractionEnabled = false
        let one = arrData[gIndex]
        one["ID"] = iID as CKRecordValue?
        one["title"] = title as CKRecordValue?
        one["url"] = url as CKRecordValue?
        one["spdata"] = spData as CKRecordValue?
        CKContainer.default().privateCloudDatabase.save(one) { (record:CKRecord?, err:Error?) in
            if err == nil {
                print("update sucess")
                // 保存成功
                DispatchQueue.main.async {
                    self.view.makeToast(NSLocalizedString("savesucess", comment: ""), duration: 3.0, position: .center)
                    self.navigationController!.popViewController(animated: true)
                }
            }else {
                // 保存不成功
                print("update fail")
                DispatchQueue.main.async {
                    self.view.makeToast(NSLocalizedString("savesucess", comment: ""), duration: 3.0, position: .center)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    // 取消
    @IBAction func cancleAction(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    
    
}
