//
//  SecondViewController.swift
//  TableTest
//
//  Created by ZhangLiangZhi on 2016/12/5.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    var micKey = "sender"
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = micKey
    }


}
