//
//  ViewController.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

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
    private var clusterViews: [CentroidView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleNumberText.delegate = self
        clusterNumberText.delegate = self
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func generateExamples() {
        guard checkInputs() else {
            return
        }
        
        for _ in 0..<exampleNumber! {
            exampleViews.append(ExampleView(boardWidth: boardWidth))
        }
        exampleViews.forEach {
            boardView.addSubview($0)
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
        
        for _ in 0..<clusterNumber! {
            var i: Int = getRandomExampleIndex()
            while clusterViews.filter({ $0.center == exampleViews[i].center }).count > 0 {
                i = getRandomExampleIndex()
            }
            let view = CentroidView(center: exampleViews[i].center,
                                    color: clusterColors[clusterViews.count])
            clusterViews.append(view)
        }
        clusterViews.forEach {
            boardView.addSubview($0)
        }
        
        clusterStatus = .clustering
        actionButton.setTitle("Go Clustering", for: .normal)
    }
    
    private func goClustering() {
        actionButton.setTitle("Continue Clustering", for: .normal)
        
        self.clusterViews.forEach {
            $0.exampleViews.removeAll()
        }
        
        self.exampleViews.forEach { (exampleView) in
            let clusterView = self.clusterViews.min(by: {
                $0.center.distance(from: exampleView.center) < $1.center.distance(from: exampleView.center)
            })!
            exampleView.cluster = clusterView
            clusterView.exampleViews.append(exampleView)
        }
        
        var shouldEnd: Bool = true
        self.clusterViews.forEach { (clusterView) in
            let newCenter = clusterView.exampleViews.averageCenter
            if clusterView.center != newCenter {
                shouldEnd = false
                clusterView.center = newCenter
            }
        }
        
        let sumDistance = exampleViews.reduce(0.0) {
            $0 + $1.center.distance(from: $1.cluster!.center).squared
        }
        costFunctionLabel.text = String.init(format: "J = %.12f", sumDistance / CGFloat(exampleNumber!))
        
        if shouldEnd {
            doneClustering()
        }
    }
    
    private func doneClustering() {
        alert(title: "Done Clustering!", message: nil)
        
        clusterStatus = .converged
        actionButton.setTitle("Reset", for: .normal)
    }
    
    private func reset() {
        exampleViews.forEach {
            $0.removeFromSuperview()
        }
        exampleViews.removeAll()
        
        clusterViews.forEach {
            $0.removeFromSuperview()
        }
        clusterViews.removeAll()
        
        clusterStatus = .empty
        
        exampleNumberText.text = ""
        clusterNumberText.text = ""
        exampleNumberText.isUserInteractionEnabled = true
        clusterNumberText.isUserInteractionEnabled = true
        
        exampleNumberText.becomeFirstResponder()
        
        costFunctionLabel.text = "J = ?"
        
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
        
        guard realExampleNumber > 0  else {
            alert(title: "Example number is greater than 0", message: nil)
            return false
        }
        
        guard realClusterNumber > 0 && realClusterNumber <= 10 else {
            alert(title: "Cluster number is between 1 and 10", message: nil)
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
