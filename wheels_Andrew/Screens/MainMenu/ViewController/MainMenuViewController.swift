//
//  ViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 16.07.2021.
//

import UIKit
import Combine

class MainMenuViewController: UIViewController {
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet var personalButton: PersonalButton!
    @IBOutlet weak var wheelsLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var defaultFont = "Gill Sans"
    let model = MenuData()
    var coordinator: MainMenuCoordinatorProtocol?
    let viewModel = MainMenuViewModel()
    private var recieveRandomtraining: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarHidden(animated: animated)
        setUpPersonalButton()
    }
    
    @IBAction func personalButtonTapped(_ sender: PersonalButton) {
        coordinator?.coordinateToQuiz(ruleUnitType: .training, testMode: .personalized)
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        coordinator?.coordinateToUserProfile()
    }
}

// MARK: - Setup
extension MainMenuViewController {
    private func setUp() {
        setUpUserButton()
        viewModel.checkIfUserLoggedIn()
        setUpPersonalButton()
        setUpCollectionView()
        setUpLabels()
        setUpNavigationBar()
        
    }
    
    private func setUpUserButton() {
        let cornerRadius = userButton.layer.frame.height / 4
        userButton.layer.cornerRadius = cornerRadius
        userButton.applyDropShadow(cornerRadius: cornerRadius)
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.register(
            UINib(nibName: MainMenuElementCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: MainMenuElementCell.reuseIdentifier
        )
        collectionView.register(
            UINib(nibName: HeaderView.reuseIdentifier, bundle: nil),
            forSupplementaryViewOfKind: HeaderView.reuseIdentifier,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
        collectionView.collectionViewLayout = .mainMenuLayout
        collectionView.reloadData()
    }
    
    func setUpPersonalButton() {
        var status = UserManagementStorage.shared.oAuthCredentials?.isLoggedIn
        if status == nil {
            status = false
        }
        personalButton.isEnabled = status!
        personalButton.setUpTitles(
            title: viewModel.personalButtonTitle,
            subTitle: viewModel.personalButtonSubTitle, isLoggedIn: status!
        )
        
    }
    
    private func setUpLabels() {
        subTitleLabel.font = .appFont(size: 17)
        greetingLabel.font = .appFont(size: 15)
    }
    
    private func setUpNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func makeNavigationBarHidden(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension MainMenuViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.menuElementsSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return model.trainingItemsArray.count
        case 1:
            return model.checkItemsArray.count
        default:
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainMenuElementCell.reuseIdentifier,
                for: indexPath
            ) as? MainMenuElementCell
            else { fatalError("Cannot create the cell") }
            cell.configure(with: model.trainingItemsArray[indexPath.item])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainMenuElementCell.reuseIdentifier,
                for: indexPath
            ) as? MainMenuElementCell
            else { fatalError("Cannot create the cell")
            }
            cell.configure(with: model.checkItemsArray[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: HeaderView.reuseIdentifier,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath
        ) as? HeaderView else {
            return UICollectionReusableView()
        }
        header.configure(with: model.headers[indexPath.section])
        return header
    }
}

extension MainMenuViewController: UICollectionViewDelegate {
    // swiftlint:disable:next cyclomatic_complexity
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                coordinator?.coordinateToRuleUnit(ruleUnitType: .training, testMode: .chapters)
            case 1:
                coordinator?.coordinateToRuleUnit(ruleUnitType: .training, testMode: .topics)
            case 2:
                coordinator?.coordinateToQuiz(ruleUnitType: .training, testMode: .random)
            default:
                return
            }
        case 1:
            switch indexPath.item {
            case 0:
                coordinator?.coordinateToRuleUnit(ruleUnitType: .control(mode: .open), testMode: .topics)
            case 1:
                coordinator?.coordinateToRuleUnit(ruleUnitType: .control(mode: .closed), testMode: .topics)
            case 2:
                coordinator?.coordinateToQuiz(ruleUnitType: .control(mode: .open), testMode: .random)
            default:
                return
            }
        default:
            return
        }
    }
}
