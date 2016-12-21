//
//  SpTableViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/19.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CloudKit

class SpTableViewController: UITableViewController {

    var arrData: [CKRecord] = []
    var refresh = UIRefreshControl()
    
    @IBOutlet var spTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh.")
        refresh.addTarget(self, action: #selector(SpTableViewController.loadData), for: .valueChanged)
        spTableView.addSubview(refresh)

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        arrData = []
        let cloudData = CKContainer.default().publicCloudDatabase
        
        let query = CKQuery(recordType: "SavePassword", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil ) )
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        cloudData.perform(query, inZoneWith: nil) { (result:[CKRecord]?, err:Error?) in
            
            if let arrData = result {
                self.arrData = arrData
                
                // 异步执行
                DispatchQueue.main.async(execute: { 
                    self.spTableView.reloadData()
                    self.refresh.endRefreshing()
                })
            }else {
                print("can not content iCloud", err)
            }
        }
        
        
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
                
                let publicData = CKContainer.default().publicCloudDatabase
                publicData.save(newSweet, completionHandler: { (record:CKRecord?, err:Error?) in
                    if err == nil {
                        DispatchQueue.main.async(execute: { 
                            print("sweet save")
                            self.spTableView.beginUpdates()
                            self.arrData.insert(newSweet, at: 0)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "spcell", for: indexPath)

        if arrData.count == 0 {
            return cell
        }
        
        let one = arrData[indexPath.row]
        
        if let title = one["title"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: one.creationDate!)
            
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = dateString
        }

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
            
            let one = arrData[indexPath.row]
            CKContainer.default().publicCloudDatabase.delete(withRecordID: one.recordID, completionHandler: { (id:CKRecordID?, err:Error?) in
                if err == nil {
                    print("delete ok")
                    
                    // 异步回来主线程操作ui
                    DispatchQueue.main.async {
                        self.arrData.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }else{
                    print(("not del", err))
                }
            })

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
