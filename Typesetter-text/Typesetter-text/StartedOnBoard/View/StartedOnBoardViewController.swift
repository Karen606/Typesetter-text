//
//  StartedOnBoardViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import UIKit
import Combine

class StartedOnBoardViewController: UIViewController {
    private var startedOnBoardPageViewController: StartedOnBoardPageViewController!

    @IBOutlet weak var firstDot: UIButton!
    @IBOutlet weak var secondDot: UIButton!
    @IBOutlet weak var startButton: UIButton!
    private var cancellables: Set<AnyCancellable> = []
    private var currentIndex = -1
    private var pages: [UIViewController] = [OnBoardFirstViewController(nibName: "OnBoardFirstViewController", bundle: nil), OnBoardSecondViewController(nibName: "OnBoardSecondViewController", bundle: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        startButton.setBackgroundImage(UIImage(color: .white), for: .normal)
        startButton.setBackgroundImage(UIImage(color: .black.withAlphaComponent(0.5)), for: .disabled)
        setCurrentPage(index: 0)
        subscribe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desinationViewController = segue.destination as? StartedOnBoardPageViewController {
            startedOnBoardPageViewController = desinationViewController
            startedOnBoardPageViewController.delegate = self
            startedOnBoardPageViewController.dataSource = self
        }
    }
    
    func pageChangedTo(index: Int) {
        switch index {
        case 0:
            firstDot.backgroundColor = .white
            secondDot.backgroundColor = .black
        case 1:
            secondDot.backgroundColor = .white
            firstDot.backgroundColor = .black
        default:
            break
        }
    }
    
    func setCurrentPage(index: Int) {
        if index == currentIndex { return }
        let direction: UIPageViewController.NavigationDirection = index < currentIndex ? .reverse : .forward
        currentIndex = index
        startedOnBoardPageViewController.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        pageChangedTo(index: index)
    }
    
    func goToMenu() {
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let navigationController = NavigationViewController(rootViewController: menuVC)
        navigationController.setAsRoot()
    }
    
    func subscribe() {
        WordsViewModel.shared.$wordPrice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                guard let self = self else { return }
                self.startButton.isEnabled = (price ?? 0) > 0
            }
            .store(in: &cancellables)
    }
    
    @IBAction func chooseFirstPage(_ sender: UIButton) {
        setCurrentPage(index: 0)
    }

    @IBAction func chooseSecondPage(_ sender: UIButton) {
        setCurrentPage(index: 1)
    }
    
    @IBAction func clickedStart(_ sender: UIButton) {
        let wordsVC = WordsViewController(nibName: "WordsViewController", bundle: nil)
        self.navigationController?.pushViewController(wordsVC, animated: true)
    }
    
}

extension StartedOnBoardViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = pageViewController.viewControllers?.first {
            let index = pages.firstIndex(of: currentPage)!
            currentIndex = index
            pageChangedTo(index: index)
        }
    }
}

extension StartedOnBoardViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController)!
        if (index == 0) {
            return nil
        } else {
            return self.pages[index - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController)!
        if (index == self.pages.count - 1) {
            return nil
        } else {
            return self.pages[index + 1]
        }
    }
}
