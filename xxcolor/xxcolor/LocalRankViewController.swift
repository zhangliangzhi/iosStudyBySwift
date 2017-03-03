//
//  LocalRankViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/28.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit

class LocalRankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "ok"
        return cell
    }

}
