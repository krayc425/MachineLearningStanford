//
//  ViewController.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

let animationDuration: TimeInterval = 0.5

class ViewController: UIViewController {
    
    @IBOutlet private weak var boardView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet fileprivate weak var exampleNumberText: UITextField!
    @IBOutlet fileprivate weak var clusterNumberText: UITextField!
    @IBOutlet private weak var costFunctionLabel: UILabel!
    @IBOutlet private weak var resetBarButton: UIBarButtonItem!
    
    private var boardWidth: Double {
        get {
            return Double(boardView.frame.width)
        }
    }
    private var exampleNumber: Int? {
        get {
            return Int(exampleNumberText.text ?? "")
        }
    }
    private var clusterNumber: Int? {
        get {
            return Int(clusterNumberText.text ?? "")
        }
    }
    
    private var clusterStatus: ClusterStatus = .empty
    private var exampleViews: [ExampleView] = []
    private var centroidViews: [CentroidView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exampleNumberText.delegate = self
        clusterNumberText.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBoardView))
        boardView.addGestureRecognizer(tapGesture)
        
        boardView.addShadow()
        actionButton.addShadow()
        costFunctionLabel.addShadow()
        exampleNumberText.addShadow()
        clusterNumberText.addShadow()
        
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func tapOnBoardView(_ gesture: UITapGestureRecognizer) {
        guard checkInputs() else {
            return
        }
        
        switch clusterStatus {
        case .empty:
            guard exampleViews.count < exampleNumber! else {
                return
            }
            
            let point = gesture.location(in: boardView)
            let newExample = ExampleView(boardWidth: boardWidth, center: point)
            exampleViews.append(newExample)
            boardView.addSubview(newExample)
        case .initialized:
            guard centroidViews.count < clusterNumber! else {
                return
            }
            
            let point = gesture.location(in: boardView)
            guard centroidViews.filter({ $0.center == point }).count == 0 else {
                return
            }
            let newCentroid = CentroidView(center: point)
            centroidViews.append(newCentroid)
            boardView.addSubview(newCentroid)
        default:
            return
        }
    }
    
    private func generateExamples() {
        guard checkInputs() else {
            return
        }
        
        while exampleViews.count < exampleNumber! {
            let newExample = ExampleView(boardWidth: boardWidth, center: nil)
            exampleViews.append(newExample)
            boardView.addSubview(newExample)
        }
        
        clusterStatus = .initialized
        actionButton.setTitle("Generate Centroids", for: .normal)
    }
    
    private func generateCentroids() {
        guard checkInputs() else {
            return
        }
        
        func getRandomExampleIndex() -> Int {
            return Int(arc4random()) % exampleNumber!
        }
        
        while centroidViews.count < clusterNumber! {
            var i: Int = getRandomExampleIndex()
            while centroidViews.filter({ $0.center == exampleViews[i].center }).count > 0 {
                i = getRandomExampleIndex()
            }
            let view = CentroidView(center: exampleViews[i].center)
            centroidViews.append(view)
            boardView.addSubview(view)
        }
        
        clusterStatus = .clustering
        actionButton.setTitle("Go Clustering", for: .normal)
    }
    
    private func goClustering() {
        guard clusterStatus == .clustering else {
            return
        }
        
        actionButton.isUserInteractionEnabled = false
        actionButton.setTitle("Clustering...", for: .normal)
        
        self.centroidViews.forEach {
            $0.exampleViews.removeAll()
        }
        
        self.exampleViews.forEach { (exampleView) in
            let centroidView = self.centroidViews.min(by: {
                $0.center.distance(from: exampleView.center) < $1.center.distance(from: exampleView.center)
            })!
            exampleView.centroid = centroidView
            centroidView.exampleViews.append(exampleView)
        }
        
        var shouldEnd: Bool = true
        self.centroidViews.forEach { (centroidView) in
            let newCenter = centroidView.exampleViews.averageCenter
            if centroidView.center != newCenter {
                shouldEnd = false
                UIView.animate(withDuration: animationDuration, animations: {
                    centroidView.center = newCenter
                })
            }
        }
        
        let sumDistance = exampleViews.reduce(0.0) {
            $0 + $1.center.distance(from: $1.centroid!.center).squared
        }
        costFunctionLabel.text = String.init(format: "J = %.12f", sumDistance / CGFloat(exampleNumber!))
        
        if shouldEnd {
            doneClustering()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [unowned self] in
                self.goClustering()
            }
        }
    }
    
    private func doneClustering() {
        alert(title: "Done Clustering!", message: nil)
        
        clusterStatus = .converged
        actionButton.isUserInteractionEnabled = true
        actionButton.setTitle("Reset", for: .normal)
    }
    
    private func reset() {
        exampleViews.forEach {
            $0.removeFromSuperview()
        }
        exampleViews.removeAll()
        
        centroidViews.forEach {
            $0.removeFromSuperview()
        }
        centroidViews.removeAll()
        
        clusterStatus = .empty
        
        exampleNumberText.text = "0"
        clusterNumberText.text = "0"
        exampleNumberText.isUserInteractionEnabled = true
        clusterNumberText.isUserInteractionEnabled = true
        
        exampleNumberText.becomeFirstResponder()
        
        costFunctionLabel.text = "J = ?"
        
        actionButton.isUserInteractionEnabled = true
        actionButton.setTitle("Generate Examples", for: .normal)
    }

    @IBAction private func doAction(_ sender: UIButton) {
        guard sender == actionButton else {
            return
        }
        
        switch clusterStatus {
        case .empty:
            generateExamples()
        case .initialized:
            generateCentroids()
        case .clustering:
            goClustering()
        case .converged:
            reset()
        }
    }
    
    @IBAction private func resetAction(_ sender: UIBarButtonItem) {
        guard sender == resetBarButton else {
            return
        }
        reset()
    }
    
    private func checkInputs() -> Bool {
        guard let realClusterNumber = self.clusterNumber,
            let realExampleNumber = self.exampleNumber else {
                alert(title: "Fill in the numbers please", message: nil)
                return false
        }
        
        guard realExampleNumber >= realClusterNumber else {
            alert(title: "Example number should be no less than cluster number", message: nil)
            return false
        }
        
        guard realExampleNumber > 0  else {
            alert(title: "Example number is greater than 0", message: nil)
            return false
        }
        
        guard realClusterNumber > 0 && realClusterNumber <= 20 else {
            alert(title: "Cluster number must lie between 1 and 20", message: nil)
            return false
        }
        
        exampleNumberText.isUserInteractionEnabled = false
        clusterNumberText.isUserInteractionEnabled = false

        exampleNumberText.resignFirstResponder()
        clusterNumberText.resignFirstResponder()
        
        return true
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.exampleNumberText {
            self.clusterNumberText.becomeFirstResponder()
            return false
        } else if textField == self.clusterNumberText {
            self.clusterNumberText.resignFirstResponder()
            return false
        }
        return true
    }
    
}
