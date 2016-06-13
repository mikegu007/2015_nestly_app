//
//  CollectionViewCell.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/2.
//  Copyright © 2016年 cicdata. All rights reserved.
//
import UIKit
import Foundation

class CollectionViewCell:UICollectionViewCell{
   
    @IBOutlet weak var collection_img: UIImageView!
    
    @IBOutlet weak var collection_text: UILabel!
    
    var model: AccountBean? {
        didSet {
            if let _ = collection_text{
                collection_text.text = model!.name
                
            }
            if let _ = collection_img {
                collection_img.layer.cornerRadius = 0;
                collection_img.layer.masksToBounds = true;
                collection_img.wxn_setImageWithURL(NSURL(string: model!.imageurl)!, placeholderImage: UIImage(named:"category")!);
                
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        collection_text.backgroundColor = theme.SDNativeBackgroundColor
        super.awakeFromNib()
        // Initialization code
    }

    

}