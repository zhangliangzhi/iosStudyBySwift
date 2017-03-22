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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Local Ranking", comment: "")
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get coreData
        arrLocalRank = []
        do {
            arrLocalRank = try context.fetch(LocalRank.fetchRequest())
            arrLocalRank.sort(by: { (a, b) -> Bool in
                a.score > b.score
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
            // 排序了
            let delRow = indexPath.row
            let one = arrLocalRank[delRow]
            context.delete(one)
            appDelegate.saveContext()
            arrLocalRank.remove(at: delRow)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocalRank.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        let one = arrLocalRank[indexPath.row]
        cell.textLabel?.text =  "\(one.score)" + " " + NSLocalizedString("point", comment: "")
        cell.textLabel?.textColor = UIColor(red: 238/255, green: 174/255, blue: 56/255, alpha: 1)

        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strTime:String = dformatter.string(from: one.ptime as! Date)
        cell.detailTextLabel?.text = strTime
        
        return cell
    }

}
