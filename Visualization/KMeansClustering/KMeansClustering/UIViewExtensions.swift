//
//  UIViewExtensions.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = CGSize.zero
    }
    
}
