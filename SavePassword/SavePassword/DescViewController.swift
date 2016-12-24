//
//  DescViewController.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class DescViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        descLabel.text = NSLocalizedString("desc", comment: "")
    }



}
