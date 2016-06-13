//
//  BrandTableCell.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/25.
//  Copyright © 2016年 cicdata. All rights reserved.
//


import Foundation
import UIKit

class BrandTableCell: UITableViewCell {
    
    @IBOutlet weak var brandImg: UIImageView!
    
    @IBOutlet weak var brand: UILabel!
    
    
    var model: BrandBean? {
        didSet {
            if let _ = brand{
                brand.text = model!.name
                
                brand.tag = (model?.id)!;
                
            }
            if let _ = brandImg {
                brandImg.layer.cornerRadius = theme.ImageCornerRadiusSamll;
                brandImg.layer.masksToBounds = true;
                if model?.imageurl.characters.count > 5 {
//                    brandImg.wxn_setImageWithURL(NSURL(string: model!.imageurl)!, placeholderImage: UIImage(named: "pop")!);

                }
//                print(model?.imageurl)
                if let _ = model?.imageurl{
                // 图片地址
                let strUrl = model?.imageurl
                //url
                let url = NSURL(string: strUrl!)
                //图片数据
                let data = NSData(contentsOfURL:url!)
                //通过得到图片数据来加载
                if data == nil{}else{
                    let image = UIImage(data: data!)
                    //把加载到的图片丢给imageView的image现实
                    brandImg.image = image}
                }
                
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