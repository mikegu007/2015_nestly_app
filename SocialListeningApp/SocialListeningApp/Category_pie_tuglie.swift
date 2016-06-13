//
//  Category_pie_tuglie.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/5/20.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class Category_pie_tuglie: UIView {
    
    @IBOutlet weak var name_label1: UILabel!
    
    @IBOutlet weak var name_label2: UILabel!
    
    @IBOutlet weak var name_label3: UILabel!
    
    @IBOutlet weak var name_label4: UILabel!
    
    @IBOutlet weak var name_label5: UILabel!
    
    @IBOutlet weak var number_label1: UILabel!
    
    @IBOutlet weak var number_label2: UILabel!
    
    @IBOutlet weak var number_label3: UILabel!
    
    @IBOutlet weak var number_label4: UILabel!
    
    @IBOutlet weak var number_label5: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var image5: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image1.hidden = true
        image2.hidden = true
        image3.hidden = true
        image4.hidden = true
        image5.hidden = true

        
    }
}