//
//  ViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit

extension UIViewController {
    func setNavigationBar(title: String?, button: UIButton?) {
        if let nextButton = button {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        }
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.semibold(size: 24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
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
