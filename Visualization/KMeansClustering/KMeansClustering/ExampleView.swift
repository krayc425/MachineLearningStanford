//
//  ExampleView.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

class ExampleView: UIView {
    
    static let exampleViewWidth: CGFloat = 5.0
    
    weak var cluster: CentroidView? {
        didSet {
            if let realCluster = cluster {
                self.backgroundColor = realCluster.backgroundColor
            }
        }
    }
    
    convenience init(boardWidth: Double) {
        self.init(frame: CGRect(x: 0,
                                y: 0,
                                width: ExampleView.exampleViewWidth,
                                height: ExampleView.exampleViewWidth))
        self.center = CGPoint(x: drand48() * boardWidth,
                              y: drand48() * boardWidth)
        self.backgroundColor = .black
        self.layer.cornerRadius = ExampleView.exampleViewWidth / 2.0
        self.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Array where Element: ExampleView {
    
    var averageCenter: CGPoint {
        get {
            let centers = self.map { $0.center }
            return centers.reduce(CGPoint(x: 0, y: 0), +) / CGFloat(self.count)
        }
    }
    
}
