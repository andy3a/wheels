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

class TrainingQuestionViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var theoryButton: UIButton!
    @IBOutlet weak var paragraphTitle: UILabel!
    @IBOutlet weak var paragraphBody: UILabel!
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
    var paragraph: Paragraph?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        sender.backgroundColor = .systemTeal
        submittedAnswer = sender
        submitButton.isEnabled = true
        submitButton.backgroundColor = .systemTeal
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        checkChosenAnswer()

    }
    @IBAction func theoryButtonPressed(_ sender: UIButton) {
        showTheParagraph()
    }
}
// MARK: SetUp
extension TrainingQuestionViewController {

    private func setUp() {
        setUpAnswerButtons()
        setUpQuestionText()
        setUpImage()
        hideTheoryElements()
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
        theoryButton.layer.cornerRadius = theoryButton.frame.height / 3
        theoryButton.applyDropShadow(cornerRadius: theoryButton.frame.height / 3)
    }
    
    private func setUpAnswerButtons() {
        guard let answersArray = answersArray else { return }
        for answer in answersArray {
            let button = AnswerButton()
            button.correctAnswerIndicator = answer.correct
            button.setUpLabel(text: answer.text)
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

    private func hideTheoryElements() {
        theoryButton.isHidden = true
        paragraphTitle.isHidden = true
        paragraphBody.isHidden = true
    }
}

// MARK: LifeCycleFunctions
extension TrainingQuestionViewController {

    private func scrollDownToAppearedTheoryButton(yOffset: CGFloat) {
        let currentOffset = scrollView.contentOffset
        scrollView.setContentOffset(CGPoint(x: 0, y: currentOffset.y + yOffset), animated: true)
    }
    
    private func checkChosenAnswer() {
        if submittedAnswer.correctAnswerIndicator == false {
            theoryButton.isHidden = false
            scrollDownToAppearedTheoryButton(yOffset: submitButton.frame.height + Constants.answerStackSpacing)
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
    }

    private func showTheParagraph() {
        paragraphTitle.text = paragraph?.chapter.name
        var body = "\(paragraph?.text ?? "")\n"
        paragraph?.articles?.forEach { article in
            body += "👉 \(article.text)\n"
        }
        paragraphBody.text = body
        paragraphTitle.isHidden = false
        paragraphBody.isHidden = false
        scrollView.scrollToView(theoryButton, animated: true)
        theoryButton.isEnabled = false
    }
    
}
