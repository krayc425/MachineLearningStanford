//
//  ClusterView.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

public let clusterColors: [UIColor] = [UIColor.red,
                                       UIColor.blue,
                                       UIColor.green,
                                       UIColor.brown,
                                       UIColor.cyan,
                                       UIColor.yellow,
                                       UIColor.purple,
                                       UIColor.gray,
                                       UIColor.orange,
                                       UIColor.magenta]

class CentroidView: UIView {
    
    static let centroidViewWidth: CGFloat = 10.0
    
    var exampleViews: [ExampleView] = []
    
    convenience init(center: CGPoint, color: UIColor) {
        self.init(frame: CGRect(x: center.x - CentroidView.centroidViewWidth / 2.0,
                                y: center.y - CentroidView.centroidViewWidth / 2.0,
                                width: CentroidView.centroidViewWidth,
                                height: CentroidView.centroidViewWidth))
        self.backgroundColor = color
        self.layer.cornerRadius = CentroidView.centroidViewWidth / 2.0
        self.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
