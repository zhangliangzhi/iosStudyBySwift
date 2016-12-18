//
//  ViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/18.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var spTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spTableView.delegate = self
        spTableView.dataSource = self
        
        let aa:String = NSLocalizedString("teststr", comment: "")
        print(aa)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spcell", for: indexPath) as! SpTableViewCell
        
        cell.textLabel?.text = "8"
        return cell
    }
}

