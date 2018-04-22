//
//  UIViewControllerExtensions.swift
//  KMeansClustering
//
//  Created by 宋 奎熹 on 2018/4/22.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil )
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
