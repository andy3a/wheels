//
//  TrainingViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 28.07.21.
//

import Foundation
import UIKit
import TinyConstraints
import Combine

class TrainingViewController: UIViewController {
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: QuizCoordinatorProtocol?
    var viewModel: QuizViewModel!
    var pageViewController: UIPageViewController!
    var currentIndex: Int!
    var pagesArray: [TrainingQuestionViewController] = []
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllElements()
        currentIndex = viewModel.selectedItem
        displayRequeredContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpButtonStyle()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let previousViewController = pageViewController(
                pageViewController,
                viewControllerBefore: currentViewController
              ) else {
            return
        }
        
        pageViewController.setViewControllers(
            [previousViewController],
            direction: .reverse,
            animated: true,
            completion: { [weak self] _ in
                self?.updateTitle()
            }
        )
        currentIndex -= 1
        handleButtonsStatus()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let nextViewController = pageViewController(
                pageViewController,
                viewControllerAfter: currentViewController
              ) else {
            return
        }
        
        pageViewController.setViewControllers(
            [nextViewController],
            direction: .forward,
            animated: true,
            completion: { [weak self] _ in
                self?.updateTitle()
            }
        )
        currentIndex += 1
        handleButtonsStatus()
    }
    
}
// MARK: Setup
extension TrainingViewController {
    
    private func displayRequeredContent() {
        switch viewModel.testMode {
        case .chapters:
            activityIndicator.stopAnimating()
            setUp()
        case .topics:
            activityIndicator.stopAnimating()
            setUp()
        case .random:
            viewModel.fetchRandomQuestions()
            viewModel.reloadPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else {return}
                    self.setUp()
                    self.activityIndicator.stopAnimating()
                }
                .store(in: &subscriptions)
            
        case .personalized:
            viewModel.fetchPesonalizedQuestions()
            viewModel.reloadPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else {return}
                    self.setUp()
                    self.activityIndicator.stopAnimating()
                }
                .store(in: &subscriptions)
        case .none:
            return
        }
    }
    
    private func setUp() {
        unhideSubviews()
        setUpPageViewController()
        updateTitle()
        handleButtonsStatus()
        setUpNavigationBar()
    }
    
    private func hideAllElements() {
        for subview in view.subviews where subview != activityIndicator {
            subview.isHidden = true
        }
    }
    
    private func unhideSubviews() {
        for subview in view.subviews where subview != activityIndicator {
            subview.isHidden = false
        }
    }
    
    private func setUpButtonStyle() {
        backButton.layer.cornerRadius = backButton.frame.height / 3
        nextButton.layer.cornerRadius = nextButton.frame.height / 3
        backButton.applyDropShadow(cornerRadius: backButton.frame.height / 3)
        nextButton.applyDropShadow(cornerRadius: nextButton.frame.height / 3)
    }
    
    private func setUpPageViewController() {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        let startingViewController = viewControllerAtIndex(index: currentIndex)
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(
            viewControllers,
            direction: .forward,
            animated: false
        )
        addChild(pageViewController)
        contentContainer.addSubview(pageViewController.view)
        pageViewController.view.edgesToSuperview()
        pageViewController.didMove(toParent: self)
        self.pageViewController = pageViewController
    }
    
    private func setUpNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
    }
}
// MARK: LifeCycpleFunctions
extension TrainingViewController {
    
    private func viewControllerAtIndex(index: Int) -> TrainingQuestionViewController {
        if !pagesArray.isEmpty {
            for coordinatior in pagesArray where coordinatior.pageIndex == index {
                return coordinatior
            }
        }
        return createNewPage(index: index)
    }
    
    func createNewPage(index: Int) -> TrainingQuestionViewController {
        let pageContentViewController = TrainingQuestionViewController()
        pageContentViewController.pageIndex = index
        pageContentViewController.questionTextValue = viewModel.questionsArray[index].text
        pageContentViewController.numberOfAnswers = viewModel.questionsArray[index].answers.count
        pageContentViewController.answersArray = viewModel.questionsArray[index].answers
        pageContentViewController.imageURL = viewModel.questionsArray[index].imageURL
        pageContentViewController.paragraph = viewModel.questionsArray[index].paragraph
        pagesArray.append(pageContentViewController)
        return pageContentViewController
    }
    
    private func updateTitle() {
        guard let currentViewController =
                pageViewController.viewControllers?.first as? TrainingQuestionViewController else {return}
        let index = currentViewController.pageIndex
        title = "\(index+1)/\(viewModel.questionsArray.count)"
    }
    
    private func handleButtonsStatus() {
        if currentIndex == 0 {
            backButton.isEnabled = false
            nextButton.isEnabled = true
            if viewModel.questionsArray.count == 1 {
                backButton.isEnabled = false
                nextButton.isEnabled = false
            }
        } else if currentIndex == viewModel.questionsArray.count - 1 {
            backButton.isEnabled = true
            nextButton.isEnabled = false
        } else {
            backButton.isEnabled = true
            nextButton.isEnabled = true
        }
    }
}

extension TrainingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as? TrainingQuestionViewController)!.pageIndex
        currentIndex = index
        guard index != 0 else { return nil }
        index -= 1
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as? TrainingQuestionViewController)!.pageIndex
        index += 1
        guard index != viewModel.questionsArray.count else { return nil }
        return viewControllerAtIndex(index: index)
    }
}

extension TrainingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let vc = pageViewController.viewControllers?.last as? TrainingQuestionViewController
        currentIndex = vc?.pageIndex
        handleButtonsStatus()
        updateTitle()
    }
}
