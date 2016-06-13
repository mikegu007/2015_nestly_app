//
//  Hot_ContentCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/26.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Alamofire

class Hot_ContentCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    var model: TableChartBean? {
        didSet {
            if let _ = label1{
                label1.text = model!.content
            }
            if let _ = label2{
                label2.text = String(model!.hotretweets)
                
            }
            if let _ = label3{
                label3.text = String(model!.comments)
                
            }
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
