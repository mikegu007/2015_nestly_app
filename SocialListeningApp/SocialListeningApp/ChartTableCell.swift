//
//  ChartTableCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/3.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Foundation

class ChartTableCell:UITableViewCell{
    
    
    @IBOutlet weak var numberlabel: UILabel!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var eyelabel: UILabel!
    
    @IBOutlet weak var transmitlabel: UILabel!
    
    @IBOutlet weak var timelabel: UILabel!
    
    
    override func awakeFromNib() {
        numberlabel.layer.cornerRadius = numberlabel.bounds.size.width/2
        numberlabel.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}