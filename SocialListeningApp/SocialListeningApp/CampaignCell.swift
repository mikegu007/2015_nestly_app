//
//  CampaignCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/4/6.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class CampaignCell: UITableViewCell {
    
    @IBOutlet weak var campaign_label: UILabel!
    
    @IBOutlet weak var button_label: UILabel!
    
    @IBOutlet weak var main_view: UIView!
    
    @IBOutlet weak var imp_label: UILabel!
    
    @IBOutlet weak var click_label: UILabel!
    
    @IBOutlet weak var ctr_label: UILabel!
    
    @IBOutlet weak var uv_label: UILabel!
    
    @IBOutlet weak var defo_image: UIImageView!
    
    @IBOutlet weak var defo_image_view: UIView!
    
    var selectDelegate:SelectIndexDelegate?;
    var sel:NSIndexPath?;
    
    var model: CampaignBean? {
        didSet {

            if let _ = campaign_label{
                campaign_label.text = model!.name
                
            }
            if let _ = imp_label{
                imp_label.text = String(model!.imp)
                
            }
            if let _ = click_label{
                click_label.text = String(model!.click)
                
            }
            if let _ = ctr_label{
                ctr_label.text = String(model!.ctr)
                
            }
            if let _ = uv_label{
                uv_label.text = String(model!.uv)
                
            }
            
            button_label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            button_label.numberOfLines = 0
//            button_label.text = "aaaaaaaaaaaaaaaaaadfasdfwdsdafdgaegasgasdasdfafafdasfasdfasdfasdfsdafasdfsafasdfasdfsadfadsfasfsdafasfasdfasfsdfegga"
            button_label.text = ""
            main_view.translatesAutoresizingMaskIntoConstraints = false
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector("expandSection:"))
            defo_image_view.userInteractionEnabled = true;
            defo_image_view.addGestureRecognizer(tap)
            
            if model?.isExpanded == false {
                defo_image.image = UIImage(named: "con_campaign_down")

            }else{
                defo_image.image = UIImage(named: "con_campaign_up")

            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print("item..");
        
    }
    
    func expandSection(tap:UITapGestureRecognizer){
        selectDelegate?.didSelectIndex(model!,sel: sel!);
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
}


protocol SelectIndexDelegate{

    func didSelectIndex(bean:CampaignBean,sel:NSIndexPath);
}