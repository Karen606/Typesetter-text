//
//  WordsViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import UIKit
import Combine

class WordsViewController: UIViewController {

    @IBOutlet weak var textView: LinedTextView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var wordsCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = WordsViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        registerKeyboardNotifications()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        wordsCountLabel.font = .medium(size: 24)
        wordsCountLabel.textColor = .white.withAlphaComponent(0.5)
        wordsCountLabel.text = "Words: \(viewModel.wordsCount)"
        priceLabel.font = .medium(size: 24)
        priceLabel.textColor = .white
        priceLabel.text = "Earned: \(viewModel.calculatePrice())"
        textView.layer.borderColor = UIColor.border.cgColor
        textView.layer.borderWidth = 6
        textView.layer.cornerRadius = 24
        textView.clipsToBounds = true
        textView.font = .medium(size: 16)
        textView.delegate = self
        menuButton.titleLabel?.font = .medium(size: 24)
        menuButton.layer.cornerRadius = 12
        endButton.titleLabel?.font = .medium(size: 24)
        endButton.layer.cornerRadius = 12
    }
    
    func subscribe() {
        viewModel.$price
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                guard let self = self else { return }
                self.priceLabel.text = "Earned: \(price ?? "0")$"
            }
            .store(in: &cancellables)
        
        viewModel.$wordsCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wordsCount in
                guard let self = self else { return }
                self.wordsCountLabel.text = "Words: \(wordsCount)"
            }
            .store(in: &cancellables)
        
        viewModel.$text
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.textView.text = text
            }
            .store(in: &cancellables)
    }

    
    @IBAction func clickedMenuButton(_ sender: UIButton) {
        viewModel.saveText { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewModel.clear()
                if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
                    self.navigationController?.popToViewController(menuVC, animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clickedEndButton(_ sender: UIButton) {
        if textView.text.isEmpty {
            self.viewModel.removeWork { success in
                self.viewModel.clear()
                if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
                    self.navigationController?.popToViewController(menuVC, animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            let dialogView = DialogView.instanceFromNib()
            dialogView.delegate = self
            dialogView.commonInit()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(dialogView)
            }
        }
    }
}

extension WordsViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.setText(text: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
            return false
        }
        return true
    }
}

extension WordsViewController: DialogViewDelegate {
    func save() {
        
        viewModel.saveProject { [weak self] success in
            guard let self = self else { return }
            
        }
        
        viewModel.removeWork { success in
            if success {
                self.viewModel.clear()
                if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
                    self.navigationController?.popToViewController(menuVC, animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func close() {
        viewModel.removeWork { [weak self] success in
            guard let self = self else { return }
            self.viewModel.clear()
            if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
                self.navigationController?.popToViewController(menuVC, animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension WordsViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(WordsViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                textView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

