//
//  TrainingQuestionViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 28.07.21.
//
import Foundation
import UIKit
import TinyConstraints
import Nuke

private enum Constants {
    static var safeAreaY: CGFloat { 34 }
    static var answerStackSpacing: CGFloat { 25 }
}

protocol ControlQuestionViewControllerProtocol: AnyObject {
    func updateStatus(index: Int, isCorrect: Bool)
    func moveToNextQuestion(pageIndex: Int)
    func checkIfTestFailed()
    func saveAnswer(questionIndex: Int, answerIndex: Int)
}

class ControlQuestionViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var submitButtonStack: UIStackView!
    @IBOutlet weak var answerButtonsStack: UIStackView!

    var pageIndex = 0
    var questionTextValue: String?
    var numberOfAnswers: Int?
    var answersArray: [Answer]?
    var imageURL: URL?
    var answerButtonArray: [AnswerButton] = []
    var submittedAnswer: AnswerButton!
    var isAnswered: Bool = false
    var controlMode: RuleUnitType?
    
    weak var delegate: ControlQuestionViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutAnswerButton()
        setUpButtonStyle()
    }

    private func layoutAnswerButton() {
        var mainStackLessThenView: Bool {
            // swiftlint:disable:next line_length
            view.frame.height - submitButton.frame.height - submitStackTopConstraint.constant > mainStack.frame.height + Constants.answerStackSpacing
        }
        if mainStackLessThenView {
            // swiftlint:disable:next line_length
            let constraintValue = view.frame.height - mainStack.frame.height - submitButton.frame.height - Constants.safeAreaY
            submitStackTopConstraint.constant = constraintValue
        }
    }

    @objc func highlightPressedAnswer(sender: AnswerButton) {
        for button in answerButtonArray where button.isPressed == true {
            button.backgroundColor = .systemBackground
            button.isPressed = false
        }
        sender.isPressed = true
        sender.backgroundColor = .systemGray
        submittedAnswer = sender
        submitButton.isEnabled = true
        submitButton.backgroundColor = .systemTeal
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        checkChosenAnswer()
    }
}
// MARK: SetUp
extension ControlQuestionViewController {

    private func setUp() {
        setUpAnswerButtons()
        setUpQuestionText()
        setUpImage()
        disableSubmitButton()
    }

    private func setUpSpacing() {
        submitButtonStack.spacing = Constants.answerStackSpacing
    }

    private func setUpButtonStyle() {
        submitButtonStack.isLayoutMarginsRelativeArrangement = true
        submitButtonStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        submitButton.layer.cornerRadius = submitButton.frame.height / 3
        submitButton.applyDropShadow(cornerRadius: submitButton.frame.height / 3)
    }

    private func setUpAnswerButtons() {
        guard let answersArray = answersArray else { return }
        for (index, answer) in answersArray.enumerated() {
            let button = AnswerButton()
            button.correctAnswerIndicator = answer.correct
            button.setUpLabel(text: answersArray[index].text)
            button.layer.cornerRadius = submitButton.frame.height / 5
            button.layer.borderWidth = 1
            let color: UIColor = .systemGray
            button.layer.borderColor = color.cgColor
            button.addTarget(self, action: #selector(highlightPressedAnswer), for: .touchUpInside)
            answerButtonArray.append(button)
            answerButtonsStack.addArrangedSubview(button)
            button.widthToSuperview()
        }
    }

    private func setUpQuestionText() {
        questionText.text = questionTextValue
    }

    private func setUpImage() {
        if let imageURL = imageURL {
            Nuke.loadImage(with: imageURL, into: questionImage)
        } else {
            questionImage.isHidden = true
        }
    }

    private func disableSubmitButton() {
        submitButton.isEnabled = false
        submitButton.backgroundColor = .systemGray
    }
}

// MARK: LifeCycleFunctions
extension ControlQuestionViewController {

    private func checkChosenAnswer() {
        switch controlMode {
        case .control(mode: .open):
            if submittedAnswer.correctAnswerIndicator == false {
                submittedAnswer.backgroundColor = .red
                answerButtonArray.forEach { answer in
                    if answer.correctAnswerIndicator == true {
                        answer.backgroundColor = .green
                    }
                }
            } else {
                submittedAnswer.backgroundColor = .green
            }
            submitButton.isEnabled = false
            submitButton.backgroundColor = .systemGray
            answerButtonArray.forEach { button in
                button.isEnabled = false
            }
            delegate?.updateStatus(index: pageIndex, isCorrect: submittedAnswer.correctAnswerIndicator!)
            isAnswered = true
            delegate?.saveAnswer(
                questionIndex: pageIndex,
                answerIndex: answerButtonArray.firstIndex(of: answerButtonArray.filter({$0.isPressed == true}).first!)!
            )
            delegate?.checkIfTestFailed()
            delegate?.moveToNextQuestion(pageIndex: pageIndex)
        case .control(mode: .closed):
            submittedAnswer.backgroundColor = .systemTeal
            submitButton.isEnabled = false
            submitButton.backgroundColor = .systemGray
            answerButtonArray.forEach { button in
                button.isEnabled = false
            }
            delegate?.updateStatus(index: pageIndex, isCorrect: submittedAnswer.correctAnswerIndicator!)
            isAnswered = true
            delegate?.saveAnswer(
                questionIndex: pageIndex,
                answerIndex: answerButtonArray.firstIndex(of: answerButtonArray.filter({$0.isPressed == true}).first!)!
            )
            delegate?.checkIfTestFailed()
            delegate?.moveToNextQuestion(pageIndex: pageIndex)
            
        default:
            return
        }
    }

}
