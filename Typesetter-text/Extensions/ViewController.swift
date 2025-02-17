//
//  ViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit

extension UIViewController {
    func setNavigationBar(leftTitle: UILabel?, button: UIButton? = nil, rightTitle: UILabel? = nil) {
        if let nextButton = button {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        }
        if let leftTitle = leftTitle {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        }
        if let rightTitle = rightTitle {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightTitle)
        }
    }
    
    @objc func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func setAsRoot() {
        UIApplication.shared.windows.first?.rootViewController = self
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
