//
//  SpTableViewCell.swift
//  SavePassword
//
//  Created by ZhangLiangZhi on 2016/12/19.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class SpTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtURL: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.isEditable = false
    }



}
