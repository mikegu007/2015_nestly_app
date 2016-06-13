//
//  Campaign_imp_uv_view.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/5/5.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class Campaign_imp_uv_view: UIView {
    
    @IBOutlet weak var button_1: UIButton!
    
    @IBOutlet weak var button_2: UIButton!
    
    @IBOutlet weak var button_3: UIButton!
    
    @IBOutlet weak var button_4: UIButton!
    
    @IBOutlet weak var button_5: UIButton!
    
    @IBOutlet weak var button_6: UIButton!

    //    required init(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)!
    //    }
    //
    var model: E_shopBean? {
        didSet {
//                        print(model?.value1)
            if let _ = button_1{
                button_1.tintColor = UIColor.whiteColor()
                button_1.setTitle("\(model!.value1)", forState: UIControlState.Normal)
                
            }
            if let _ = button_2{
                button_2.tintColor = UIColor.whiteColor()
                button_2.setTitle("\(model!.value2)", forState: UIControlState.Normal)
                
            }
            if let _ = button_3{
                button_3.tintColor = UIColor.whiteColor()
                button_3.setTitle("\(model!.value3)", forState: UIControlState.Normal)
                
            }
            if let _ = button_4{
                button_4.tintColor = UIColor.whiteColor()
                button_4.setTitle("\(model!.value4)", forState: UIControlState.Normal)
                
            }
            if let _ = button_5{
                button_5.tintColor = UIColor.whiteColor()
                button_5.setTitle("\(model!.value5)", forState: UIControlState.Normal)
                
            }
            
            if let _ = button_6{
                button_6.tintColor = UIColor.whiteColor()
                button_6.setTitle("\(model!.value6)", forState: UIControlState.Normal)
                
            }
        }
    }
    //
    //    // Only override drawRect: if you perform custom drawing.
    //    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect) {
    //        //        makeupUI()
    //        load_data()
    //    }
    //    func load_data(){
    //        
    //
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button_1.titleLabel
        
    }
    
    
}