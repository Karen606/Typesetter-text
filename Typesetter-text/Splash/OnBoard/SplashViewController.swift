//
//  ViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickedNext(_ sender: UIButton) {
        let nameVC = NameViewController(nibName: "NameViewController", bundle: nil)
        self.navigationController?.pushViewController(nameVC, animated: true)
    }
    
}

