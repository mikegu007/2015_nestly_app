//
//  KeywordTableCell.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/25.
//  Copyright © 2016年 cicdata. All rights reserved.
//


import Foundation
import UIKit

class KeywordTableCell: UITableViewCell {
    
    @IBOutlet weak var keywordImg: UIImageView!

    @IBOutlet weak var keyword: UILabel!

    
    var model: AccountBean? {
        didSet {
            if let _ = keyword{
                keyword.text = model!.name
                
            }
            if let _ = keywordImg {
                keywordImg.layer.cornerRadius = theme.ImageCornerRadiusSamll;
                keywordImg.layer.masksToBounds = true;
                keywordImg.wxn_setImageWithURL(NSURL(string: model!.imageurl)!, placeholderImage: UIImage(named:"keyword")!);
                
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}