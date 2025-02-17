//
//  MenuViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit
import Combine

class MenuViewController: UIViewController {

    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = ProjectsViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$price
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                guard let self = self else { return }
                self.priceLabel.text = "Earned: \(price.formatString())$"
            }
            .store(in: &cancellables)
        
        viewModel.$words
            .receive(on: DispatchQueue.main)
            .sink { [weak self] words in
                guard let self = self else { return }
                self.wordsLabel.text = "Written Words: \(words)"
            }
            .store(in: &cancellables)
    }

    @IBAction func clickedStarted(_ sender: UIButton) {
        if let work = viewModel.work {
            WordsViewModel.shared.setWork(work: work)
            let wordsVC = WordsViewController(nibName: "WordsViewController", bundle: nil)
            self.navigationController?.pushViewController(wordsVC, animated: true)
        } else {
            let startedOnBoardVC = UIStoryboard(name: "StartedOnBoard", bundle: .main).instantiateViewController(identifier: "StartedOnBoardViewController")
            self.navigationController?.pushViewController(startedOnBoardVC, animated: true)
        }
    }
    
    @IBAction func clickedAchievements(_ sender: UIButton) {
        let achievementsVC = AchievementsViewController(nibName: "AchievementsViewController", bundle: nil)
        self.navigationController?.pushViewController(achievementsVC, animated: true)
    }
    
    @IBAction func clickedSettings(_ sender: UIButton) {
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}
