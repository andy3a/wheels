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

class ControlViewController: UIViewController {
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusStack: UIStackView!
    
    var coordinator: QuizCoordinatorProtocol?
    var viewModel: QuizViewModel!
    var pageViewController: UIPageViewController!
    var currentIndex: Int!
    var topStackButtonsArray: [StatusStackButton] = []
    var pagesArray: [ControlQuestionViewController] = []
    private var subscriptions = Set<AnyCancellable>()
    var timer: Timer!
    var timeLimit: TimeInterval = 120
    let timeLimitMax: TimeInterval = 120
    let formatter = DateComponentsFormatter()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            timer.invalidate()
        }
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
                self?.updateChosenQuestionButton(index: (self?.currentIndex )!)
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
                self?.updateChosenQuestionButton(index: (self?.currentIndex )!)
            }
        )
        currentIndex += 1
        handleButtonsStatus()
    }
}
// MARK: Setup
extension ControlViewController {
    
    private func displayRequeredContent() {
        switch viewModel.testMode {
        case .random:
            viewModel.fetchRandomControlSection()
            viewModel.reloadPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else {return}
                    self.setUp()
                    self.activityIndicator.stopAnimating()
                    self.applyShadowForButtons()
                }
                .store(in: &subscriptions)
        case .chapters:
            return
        case .topics:
            guard case .control(let mode) = viewModel.ruleUnitType else {return}
            switch mode {
            case .closed:
                viewModel.fetchControlSection(topic: viewModel.topic!)
                viewModel.reloadPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        guard let self = self else {return}
                        self.setUp()
                        self.activityIndicator.stopAnimating()
                        self.applyShadowForButtons()
                    }
                    .store(in: &subscriptions)
                
            case .open:
                viewModel.fetchControlSection(topic: viewModel.topic!)
                viewModel.reloadPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        guard let self = self else {return}
                        self.setUp()
                        self.activityIndicator.stopAnimating()
                        self.applyShadowForButtons()
                    }
                    .store(in: &subscriptions)
            }
        case .none:
            return
        case .personalized:
            return
        }
    }
    
    private func setUp() {
        unhideSubviews()
        setUpPageViewController()
        setUpButtonCornerRadius()
        setUpTimer()
        setUpStatusStack()
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
    
    private func setUpTimer() {
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
        
        self.timer = timer
    }
    
    @objc func updateCounter() {
        let timeLimitString = formatter.string(from: timeLimit)!
        if timeLimit >= 0 {
            title = String(timeLimitString)
            timeLimit -= 1
        } else {
            timer.invalidate()
            viewModel.duration = Int(timeLimitMax - timeLimit)
            viewModel.uploadControlResults()
            coordinator?.coordinateToResultScreen(result: "Время истекло")
        }
    }
    
    func updateChosenQuestionButton(index: Int) {
        topStackButtonsArray.forEach { button in
            button.isChoosen(isChoosen: false)
        }
        topStackButtonsArray[index].isChoosen(isChoosen: true)
    }
    
    private func setUpButtonCornerRadius() {
        backButton.layer.cornerRadius = backButton.frame.height / 3
        nextButton.layer.cornerRadius = nextButton.frame.height / 3
    }
    
    private func applyShadowForButtons() {
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
extension ControlViewController {
    
    private func viewControllerAtIndex(index: Int) -> ControlQuestionViewController {
        if !pagesArray.isEmpty {
            for pageContentViewController in pagesArray where pageContentViewController.pageIndex == index {
                pagesArray.forEach { page in
                    page.delegate = self
                }
                return pageContentViewController
            }
        }
        return createNewPage(index: index)
    }
    
    func createNewPage(index: Int) -> ControlQuestionViewController {
        let pageContentViewController = ControlQuestionViewController()
        pageContentViewController.pageIndex = index
        pageContentViewController.questionTextValue = viewModel.questionsArray[index].text
        pageContentViewController.numberOfAnswers = viewModel.questionsArray[index].answers.count
        pageContentViewController.answersArray = viewModel.questionsArray[index].answers
        pageContentViewController.imageURL = viewModel.questionsArray[index].imageURL
        pageContentViewController.controlMode = viewModel.ruleUnitType
        pagesArray.append(pageContentViewController)
        pagesArray.last!.delegate = self
        return pageContentViewController
    }
    
    private func handleButtonsStatus() {
        if currentIndex == 0 {
            backButton.isEnabled = false
            nextButton.isEnabled = true
        } else if currentIndex == viewModel.questionsArray.count - 1 {
            backButton.isEnabled = true
            nextButton.isEnabled = false
        } else {
            backButton.isEnabled = true
            nextButton.isEnabled = true
        }
    }
    
    private func setUpStatusStack() {
        for index in viewModel.questionsArray.indices {
            let button = StatusStackButton()
            button.setUpLabel(text: "\(index + 1)")
            button.layer.cornerRadius = 10
            button.buttonIndex = index
            button.addTarget(self, action: #selector(topStackButtonPressed), for: .touchUpInside)
            topStackButtonsArray.append(button)
            statusStack.addArrangedSubview(button)
        }
        topStackButtonsArray.first?.isChoosen(isChoosen: true)
    }
    
    @objc func topStackButtonPressed(sender: StatusStackButton) {
        topStackButtonsArray.forEach { button in
            button.isChoosen(isChoosen: false)
        }
        sender.isChoosen(isChoosen: true)
        currentIndex = sender.buttonIndex
        handleButtonsStatus()
        let selectedViewController = viewControllerAtIndex(index: sender.buttonIndex!)
        self.pageViewController.setViewControllers(
            [selectedViewController],
            direction: .forward,
            animated: false
        )
    }
    
    func displayChosenPage(pageIndex: Int) {
        topStackButtonsArray.forEach { button in
            button.isChoosen(isChoosen: false)
        }
        topStackButtonsArray[pageIndex].isChoosen(isChoosen: true)
        currentIndex = pageIndex
        handleButtonsStatus()
        let selectedViewController = viewControllerAtIndex(index: pageIndex)
        self.pageViewController.setViewControllers(
            [selectedViewController],
            direction: .forward,
            animated: false
        )
    }
}

extension ControlViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as? ControlQuestionViewController)!.pageIndex
        currentIndex = index
        guard index != 0 else { return nil }
        index -= 1
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        var index = (viewController as? ControlQuestionViewController)!.pageIndex
        index += 1
        guard index != viewModel.questionsArray.count else { return nil }
        return viewControllerAtIndex(index: index)
    }
}

extension ControlViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let vc = pageViewController.viewControllers?.last as? ControlQuestionViewController
        currentIndex = vc?.pageIndex
        updateChosenQuestionButton(index: currentIndex)
        handleButtonsStatus()
    }
}

extension ControlViewController: ControlQuestionViewControllerProtocol {
    func moveToNextQuestion(pageIndex: Int) {
        var answeredQuestions: [Int] = []
        for page in pagesArray where page.isAnswered == true {
            answeredQuestions.append(page.pageIndex)
        }
        guard viewModel.questionsArray.count != answeredQuestions.count else { return }
        var nonAnsweredQuestions = topStackButtonsArray.filter { $0.isAnswered == false}
        nonAnsweredQuestions.sort(by: { $0.buttonIndex! < $1.buttonIndex!})
        if !nonAnsweredQuestions.filter({ $0.buttonIndex! > pageIndex }).isEmpty {
            let nextQuestions = nonAnsweredQuestions.filter { $0.buttonIndex! > pageIndex }
            displayChosenPage(pageIndex: nextQuestions.first!.buttonIndex!)
        } else {
            displayChosenPage(pageIndex: nonAnsweredQuestions.first!.buttonIndex!)
        }
        
    }
    
    func updateStatus(index: Int, isCorrect: Bool) {
        guard case .control(let mode) = viewModel.ruleUnitType else {return}
        topStackButtonsArray[index].isCorrectAnswer(answer: isCorrect, controlMode: mode)
        topStackButtonsArray[index].isAnswered = true
    }
    
    func checkIfTestFailed() {
        guard case .control(let mode) = viewModel.ruleUnitType else {return}
        switch mode {
        case .open:
            if topStackButtonsArray.filter({ $0.isCorrectlyAnswered == false}).count == 2 {
                viewModel.duration = Int(timeLimitMax - timeLimit)
                viewModel.uploadControlResults()
                timer.invalidate()
                coordinator?.coordinateToResultScreen(result: "Вы ответили неправильно на 2 вопроса")
            }
            guard topStackButtonsArray.filter({$0.isAnswered}).count == viewModel.questionsArray.count else { return }
            viewModel.duration = Int(timeLimitMax - timeLimit)
            viewModel.uploadControlResults()
            timer.invalidate()
            coordinator?.coordinateToResultScreen(result: "Вы прошли контроль")
        case .closed:
            guard topStackButtonsArray.filter({$0.isAnswered}).count == viewModel.questionsArray.count else { return }
            viewModel.duration = Int(timeLimitMax - timeLimit)
            viewModel.uploadControlResults()
            timer.invalidate()
            let incorrectAnswerCount = topStackButtonsArray.filter({ $0.isCorrectlyAnswered == false}).count
            if incorrectAnswerCount >= 2 {
                coordinator?.coordinateToResultScreen(
                    result: "Вы не прошли контроль, неправильно отвечено \(incorrectAnswerCount) вопросов"
                )
            } else {
                coordinator?.coordinateToResultScreen(result: "Вы прошли контроль")
            }
        }
    }
    
    func saveAnswer(questionIndex: Int, answerIndex: Int) {
        viewModel.saveAnswer(questionIndex: questionIndex, answerIndex: answerIndex)
    }
}
