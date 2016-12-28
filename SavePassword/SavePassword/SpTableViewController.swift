//
//  SpTableViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/19.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CloudKit

var arrData: [CKRecord] = []
var gIndex = 0

class SpTableViewController: UITableViewController {

    var refresh = UIRefreshControl()
    
    @IBOutlet var spTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("SavePassword", comment: "")
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refresh.addTarget(self, action: #selector(SpTableViewController.loadData), for: .valueChanged)
        spTableView.addSubview(refresh)

        setupCloudKitSubscription()
        
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: NSNotification.Name(rawValue: "peformReloaded"), object: nil)
        }

//        let a = NSLocale.preferredLanguages
//        print(a)
        
        
        navigationController?.navigationBar.tintColor = UIColor.white


        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spTableView.reloadData()
    }
    
    func setupCloudKitSubscription()  {
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "subscribed") == false {
            let predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
            let subscription = CKSubscription(recordType: "SavePassword", predicate: predicate, options: .firesOnRecordCreation)
            
            let notificationInfo = CKNotificationInfo()
            notificationInfo.alertLocalizationKey = NSLocalizedString("Add", comment: "")
            notificationInfo.shouldBadge = true
            subscription.notificationInfo = notificationInfo
            
            let cloudData = CKContainer.default().privateCloudDatabase
            cloudData.save(subscription) { (sub:CKSubscription?, err:Error?) in
                if err == nil {
                    userDefault.set(true, forKey: "subscribed")
                    userDefault.synchronize()
                }else {
                    print("CloudKit error", err?.localizedDescription)
                    self.alertUIError(err: err)
                }
            }
            
        }
        

    }
    
    func loadData() {
        arrData = []
        let cloudData = CKContainer.default().privateCloudDatabase
        
        let query = CKQuery(recordType: "SavePassword", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil ) )
        query.sortDescriptors = [NSSortDescriptor(key: "ID", ascending: true)]
        cloudData.perform(query, inZoneWith: nil) { (result:[CKRecord]?, err:Error?) in
            
            if let getData = result {
                arrData = getData
                // 异步执行
                DispatchQueue.main.async(execute: { 
                    self.spTableView.reloadData()
                    self.refresh.endRefreshing()
                    self.view.layoutSubviews()
                })
            }else {
                DispatchQueue.main.async(execute: {
//                    print("loadData can not content iCloud", err)
                    self.alertUIError(err: err)
                })
            }
        }
        
        
    }
    
    func alertUIError(err: Error?) {
        let strErr:String = (err?.localizedDescription)!
        print(strErr.lengthOfBytes(using: .utf8))
        
        if strErr.lengthOfBytes(using: .utf8) > 100 {
            return
        }
        
        // 弹框出错
        let alert = UIAlertController(title: "⚠️ iCloud ⚠️", message: strErr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action:UIAlertAction) in
//            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString) as! URL
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(settingsUrl)
//            }

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func AddSwiffer(_ sender: Any) {
        let alert = UIAlertController(title: "Send Swiffer", message: "go send swiffer", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Your sweet"
        }
        
        alert.addAction(UIAlertAction(title: "send", style: .default, handler: { (action: UIAlertAction) in
            let textField = alert.textFields?.first
            if textField?.text != "" {
                let title:String = (textField?.text)!
                print(title)
                
                let newSweet = CKRecord(recordType: "SavePassword")
                newSweet["title"] = title as CKRecordValue?
                print(newSweet)
                
                let cloudData = CKContainer.default().privateCloudDatabase
                cloudData.save(newSweet, completionHandler: { (record:CKRecord?, err:Error?) in
                    if err == nil {
                        DispatchQueue.main.async(execute: { 
                            print("sweet save")
                            self.spTableView.beginUpdates()
                            arrData.insert(newSweet, at: 0)
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.spTableView.insertRows(at: [indexPath], with: .top)
                            self.spTableView.endUpdates()
                        })
                    }else {
                        print("no save", err)
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spcell", for: indexPath) as! SpTableViewCell

        if arrData.count == 0 {
            return cell
        }
        
        let one = arrData[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: one.modificationDate!)
        
        let iID:Int64 = (one.value(forKey: "ID") as! Int64?)!
        cell.txtID.text = "ID:" + String(iID)
        cell.txtDate.text = dateString
        cell.txtTitle.text = one.value(forKey: "title") as! String?
        cell.txtURL.text = one.value(forKey: "url") as! String?
        cell.textView.text = one.value(forKey: "spdata") as! String?

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            gIndex = 0
            self.view.isUserInteractionEnabled = false
            let one = arrData[indexPath.row]
            CKContainer.default().privateCloudDatabase.delete(withRecordID: one.recordID, completionHandler: { (id:CKRecordID?, err:Error?) in
                if err == nil {
                    print("delete ok")
                    
                    // 异步回来主线程操作ui
                    DispatchQueue.main.async {
                        arrData.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }else{
                    print(("not del", err))
                    // 错误弹框
                    self.alertUIError(err: err)
                }
                self.view.isUserInteractionEnabled = true
            })

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gIndex = indexPath.row
        let updateController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "updatesp") as! UpdateViewController
        navigationController!.pushViewController(updateController, animated: true)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
