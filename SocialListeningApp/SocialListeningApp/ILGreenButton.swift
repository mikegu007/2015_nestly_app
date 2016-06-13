//
//  ILGreenButton.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/29.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class ILGreenBUtton: UIButton {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self
    }
}