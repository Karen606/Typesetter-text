//
//  AchievementsViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import UIKit

class AchievementsViewController: UIViewController {
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var achievementsImageView: [UIImageView]!
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        titleLabel.font = .semibold(size: 24)
        titleLabel.textColor = .white
        titleLabel.text = "Achievements"
        setNavigationBar(leftTitle: titleLabel)
        menuButton.titleLabel?.font = .medium(size: 24)
        titleLabels.forEach({ $0.font = .semibold(size: 24 )})
        guard let achievement = achievement() else { return }
        for index in 0..<achievement {
            achievementsImageView[index].isHighlighted = true
        }
    }
    
    func achievement() -> Int? {
        switch ProjectsViewModel.shared.words {
        case 3000...:
            return 4
        case 900...:
            return 3
        case 500...:
            return 2
        case 300...:
            return 1
        default:
            return nil
        }
    }
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
