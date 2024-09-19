//
//  NameViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        nameTextField.delegate = self
        nextButton.setBackgroundImage(UIImage(color: .white), for: .normal)
        nextButton.setBackgroundImage(UIImage(color: .black.withAlphaComponent(0.5)), for: .disabled)
    }
    
    @IBAction func clickedNextButton(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        CoreDataManager.shared.registerUser(name: name) { [weak self] success in
            guard let self = self else { return }
            if success {
                let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
                let navigationVC = NavigationViewController(rootViewController: menuVC)
                navigationVC.setAsRoot()
            }
        }
    }
}

extension NameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
}
