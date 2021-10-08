//
//  UserViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 12.08.21.
//

import Foundation
import UIKit
import KDCircularProgress
import TinyConstraints
import Combine

class UserViewController: UIViewController {
    @IBOutlet weak var personalButton: PersonalButton!
    @IBOutlet weak var personalControlButton: PersonalButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var circleDiagramContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: UserViewModel!
    var coordinator: UserCoordinatorProtocol!
    var subscription: AnyCancellable?
    let progress = KDCircularProgress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarVisible(animated: animated)
        setUpButtons()
    }
    
    @IBAction func peronalTrainingButtonPressed(_ sender: PersonalButton) {
        coordinator?.coordinateToQuiz(ruleUnitType: .training, testMode: .personalized)
    }
    
    @objc func backToRootVCAction() {
        coordinator.returnToMainScreen()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        viewModel.logOutUser()
        coordinator.returnToMainScreen()
    }
}

// MARK: SetUp
extension UserViewController {
    
    func setUp() {
        setUpNavigationBar()
        setUpExitButton()
        setUpSubscription()
        viewModel.fetchPersentage()
        setUpCircleDiagram()
    }
    
    private func setUpButtons() {
        personalButton.setUpTitles(
            title: viewModel.personalButtonTitle,
            subTitle: viewModel.personalButtonSubTitle,
            isLoggedIn: true
        )
        personalControlButton.setUpTitles(
            title: viewModel.controlHistoryTitle,
            subTitle: viewModel.controlHistorySubTitle,
            isLoggedIn: true
        )
    }
    
    private func setUpExitButton() {
        
        let color = UIColor.systemGray
        exitButton.layer.borderWidth = 0.5
        exitButton.layer.borderColor = color.cgColor
        exitButton.layer.cornerRadius = exitButton.frame.height / 3
    }
    
    private func setUpNavigationBar() {
        title = viewModel.username
        
        let backToRootVCButton = UIBarButtonItem.init(
            title: "Back",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(backToRootVCAction)
        )
        backToRootVCButton.image = UIImage(systemName: "arrow.left")
        self.navigationItem.setLeftBarButton(backToRootVCButton, animated: true)
    }
    
    private func makeNavigationBarVisible(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setUpSubscription() {
        subscription = viewModel.dataRecieverTriggerPublisher
            .sink(receiveValue: { _ in
                self.activityIndicator.stopAnimating()
                self.displayActualPercentage()
            })
    }
}

// MARK: LifeCycleFunctions
extension UserViewController {
    
    private func setUpCircleDiagram() {
        progress.startAngle = -90
        progress.progressThickness = 0.3
        progress.trackThickness = 0.4
        progress.clockwise = true
        progress.gradientRotateSpeed = 0
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.glowAmount = 0
       
        progress.trackColor = .systemGray6
        progress.set(
            colors:
                UIColor(red: 93.0/255.0, green: 89.0/255.0, blue: 197.0/255.0, alpha: 1.0),
                UIColor(red: 112.0/255.0, green: 186.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        )
        
        circleDiagramContainer.addSubview(progress)
        progress.edgesToSuperview()
        progress.centerXToSuperview()
    }
        private func displayActualPercentage() {
        guard let persentage = self.viewModel.persentage else {return}
        let angle = 360.0 / 100.0 * persentage
            progress.animate(toAngle: angle, duration: 0.5, completion: {_ in
            let label = UILabel()
            self.progress.addSubview(label)
            label.text = "\(persentage)%\nправильных\nответов"
            label.font = .appFontSemiBold(size: 20)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.centerXToSuperview()
            label.centerYToSuperview()
        })
    }

}
