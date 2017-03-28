//
//  LocalRankViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/28.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import CoreData

class LocalRankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    var arrLocalRank:[LocalRank] = []
    var arrMaxTimeRank:[MaxTimeRank] = []
    
    var isShowMaxTimeRank = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Local Ranking", comment: "")
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        // 在右侧添加一个按钮
        let barButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMaxTimeRank))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    

    func showMaxTimeRank() {
        if isShowMaxTimeRank {
            isShowMaxTimeRank = false
            self.title = NSLocalizedString("Local Ranking", comment: "")
        }else {
            isShowMaxTimeRank = true
            self.title = NSLocalizedString("Play MaxTime", comment: "")
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get coreData
        arrLocalRank = []
        arrMaxTimeRank = []
        do {
            arrLocalRank = try context.fetch(LocalRank.fetchRequest())
            arrMaxTimeRank = try context.fetch(MaxTimeRank.fetchRequest())
            
            arrLocalRank.sort(by: { (a, b) -> Bool in
                return a.score > b.score
            })
            arrMaxTimeRank.sort(by: { (a, b) -> Bool in
                return a.score > b.score
            })
        }catch {
            print("getting coreData error")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let delRow = indexPath.row
            if isShowMaxTimeRank {
                let one = arrMaxTimeRank[delRow]
                context.delete(one)
                appDelegate.saveContext()
                arrMaxTimeRank.remove(at: delRow)
            } else {
                let one = arrLocalRank[delRow]
                context.delete(one)
                appDelegate.saveContext()
                arrLocalRank.remove(at: delRow)
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowMaxTimeRank {
            return arrMaxTimeRank.count
        } else {
            return arrLocalRank.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if isShowMaxTimeRank {
            let one = arrMaxTimeRank[indexPath.row]
            cell.textLabel?.text =  "\(one.score)" + " " + NSLocalizedString("point", comment: "")
            cell.textLabel?.textColor = UIColor(red: 238/255, green: 174/255, blue: 56/255, alpha: 1)
            let strTime:String = dformatter.string(from: one.ptime as! Date)
            cell.detailTextLabel?.text = strTime
        } else {
            let one = arrLocalRank[indexPath.row]
            cell.textLabel?.text =  "\(one.score)" + " " + NSLocalizedString("point", comment: "")
            cell.textLabel?.textColor = UIColor(red: 238/255, green: 174/255, blue: 56/255, alpha: 1)
            let strTime:String = dformatter.string(from: one.ptime as! Date)
            cell.detailTextLabel?.text = strTime
        }

        return cell
    }

}
