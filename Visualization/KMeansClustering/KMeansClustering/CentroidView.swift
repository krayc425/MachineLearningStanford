//
//  CentroidView.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

class CentroidView: UIView {
    
    static let centroidViewWidth: CGFloat = 30.0
    static let centroidLineWidth: CGFloat = 3.0
    
    var color: UIColor = .clear
    var exampleViews: [ExampleView] = []
    
    override func draw(_ rect: CGRect) {
        self.color.set()
        
        let path1 = UIBezierPath()
        path1.lineWidth = CentroidView.centroidLineWidth
        path1.lineCapStyle = .round
        path1.lineJoinStyle = .round
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: CentroidView.centroidViewWidth, y: CentroidView.centroidViewWidth))
        
        let path2 = UIBezierPath()
        path2.lineWidth = CentroidView.centroidLineWidth
        path2.lineCapStyle = .round
        path2.lineJoinStyle = .round
        path2.move(to: CGPoint(x: 0, y: CentroidView.centroidViewWidth))
        path2.addLine(to: CGPoint(x: CentroidView.centroidViewWidth, y: 0))
        
        path1.stroke()
        path2.stroke()
    }
    
    convenience init(center: CGPoint) {
        self.init(frame: CGRect(x: center.x - CentroidView.centroidViewWidth / 2.0,
                                y: center.y - CentroidView.centroidViewWidth / 2.0,
                                width: CentroidView.centroidViewWidth,
                                height: CentroidView.centroidViewWidth))
        self.backgroundColor = .clear
        self.color = UIColor.random()
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
                        self.alpha = 0.0
        },
                       completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
