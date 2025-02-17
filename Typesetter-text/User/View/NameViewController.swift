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
    private let viewModel = UserViewModel.shared
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        nameTextField.delegate = self
        nextButton.setBackgroundImage(UIImage(color: .white), for: .normal)
        nextButton.setBackgroundImage(UIImage(color: .black.withAlphaComponent(0.5)), for: .disabled)
    }
    
    @IBAction func clickedNextButton(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        viewModel.saveUser { [weak self] success in
            guard let self = self else { return }
            if success {
                let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
                let navigationVC = NavigationViewController(rootViewController: menuVC)
                navigationVC.setAsRoot()
            }
        }
//        CoreDataManager.shared.saveUser(name: name, photo: nil) { [weak self] success in
//            guard let self = self else { return }
//            if success {
//                let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
//                let navigationVC = NavigationViewController(rootViewController: menuVC)
//                navigationVC.setAsRoot()
//            }
//        }
    }
}

extension NameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.name = textField.text
        nextButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
}
