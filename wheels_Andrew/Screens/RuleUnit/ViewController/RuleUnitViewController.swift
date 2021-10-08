//
//  RuleUnit.swift
//  wheels_Andrew
//
//  Created by Andrew on 20.07.21.
//

import Foundation
import UIKit
import Combine

class RuleUnitViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var coordinator: RuleUnitCoordinatorProtocol?
    var viewModel: RuleUnitViewModel!
    private var subscriptions = Set<AnyCancellable>()
    private var subscription: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.fetchUnitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Setup
extension RuleUnitViewController {
    private func setUp() {
        setUpTitle()
        setUpCollectionView()
        setUpSubscriptions()
        setUpNavigationBar()
    }
    
    private func setUpTitle() {
        title = viewModel.navigationBarHeader
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: RuleUnitCollectionViewCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: RuleUnitCollectionViewCell.reuseIdentifier
        )
        collectionView.collectionViewLayout = .ruleUnitLayout
    }
    
    private func setUpSubscriptions() {
        viewModel.reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private func setUpNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
    }
}

// MARK: - UICollectionViewDataSource
extension RuleUnitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.elements.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RuleUnitCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? RuleUnitCollectionViewCell else {
            fatalError("Cannot create the cell")
        }
        cell.configure(with: viewModel.elements[indexPath.item].name)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RuleUnitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.currentTestMode {
        case .chapters:
            switch viewModel.currentRuleUnitType {
            case .training:
                let id = viewModel.elements[indexPath.item].id
                coordinator?.coordinateToChooseQuestion(
                    testMode: .chapters,
                    id: id,
                    header: viewModel.elements[indexPath.item].name
                )
            case .control:
                return
            }
        case .topics:
            switch viewModel.currentRuleUnitType {
            case .training:
                let id = viewModel.elements[indexPath.item].id
                coordinator?.coordinateToChooseQuestion(
                    testMode: .topics,
                    id: id,
                    header: viewModel.elements[indexPath.item].name
                )
            case .control:
                coordinator?.goToControlViewController(
                    ruleUnitType: viewModel.currentRuleUnitType,
                    testMode: .topics,
                    topic: viewModel.elements[indexPath.item].id
                )
            }
            
        case .random:
            return
        case .personalized:
            return
        }
    }
}
