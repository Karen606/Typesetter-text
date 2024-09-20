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
        let dialogView = DialogView.instanceFromNib()
        dialogView.delegate = self
        dialogView.commonInit()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(dialogView)
        }
    }
}

extension WordsViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.setText(text: textView.text)
    }
}

extension WordsViewController: DialogViewDelegate {
    func save() {
        viewModel.saveProject { [weak self] success in
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
    
    func close() {
        viewModel.removeWork()
        viewModel.clear()
        if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
