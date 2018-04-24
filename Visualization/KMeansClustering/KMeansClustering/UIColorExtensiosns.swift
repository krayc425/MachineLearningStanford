//
//  UIColorExtensiosns.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/23.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        let r: Int = Int(arc4random() % 255)
        let g: Int = Int(arc4random() % 255)
        let b: Int = Int(arc4random() % 255)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
}
