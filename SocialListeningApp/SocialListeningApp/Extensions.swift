//
//  Extensions.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit


/// 对UIView的扩展
extension UIView {
    /// X值
    var x: CGFloat {
        return self.frame.origin.x
    }
    /// Y值
    var y: CGFloat {
        return self.frame.origin.y
    }
    /// 宽度
    var width: CGFloat {
        return self.frame.size.width
    }
    ///高度
    var height: CGFloat {
        return self.frame.size.height
    }
    var size: CGSize {
        return self.frame.size
    }
    var point: CGPoint {
        return self.frame.origin
    }
}

extension UIImageView {
    
    func wxn_setImageWithURL(url: NSURL, placeholderImage: UIImage) {
        self.sd_setImageWithURL(url, placeholderImage: placeholderImage)
    }
    
}

// UIColor的扩展
extension UIColor {
    class func colorWith(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        return color
    }
    
}

