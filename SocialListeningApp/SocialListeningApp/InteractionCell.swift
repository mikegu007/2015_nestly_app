//
//  InteractionCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/26.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Alamofire

class InteractionCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label1_width: NSLayoutConstraint!
    
    @IBOutlet weak var label2_width: NSLayoutConstraint!
    
    @IBOutlet weak var label3_width: NSLayoutConstraint!
    
    @IBOutlet weak var label4_width: NSLayoutConstraint!
    
    
    var model: TableChartBean? {
        didSet {
            if let _ = label1{
                label1.text = model!.name
            }
            if let _ = label2{
                label2.text = String(model!.activeMention)
                
            }
            if let _ = label3{
                label3.text = String(model!.passiveMention)
                
            }
            if let _ = label4{
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