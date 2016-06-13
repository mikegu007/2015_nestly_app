//
//  DataViewCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/4.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit

class DataViewCell: UITableViewCell {
    
    @IBOutlet weak var label_data: UILabel!
    
    @IBOutlet weak var dataView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label_data.textColor = UIColor.darkGrayColor()
        
        dataView.layer.masksToBounds = true
        dataView.layer.cornerRadius = 10
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}