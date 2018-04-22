//
//  CGPointExtensions.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(from aPoint: CGPoint) -> CGFloat {
        return ((self.x - aPoint.x).squared + (self.y - aPoint.y).squared).squareRoot()
    }
    
    static func +(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func /(_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
}
