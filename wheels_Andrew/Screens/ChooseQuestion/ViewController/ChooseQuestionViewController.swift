//
//  ChooseQuestionViewController.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation
import UIKit
import Combine

class ChooseQuestionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var coordinator: ChooseQuestionCoordinatorProtocol?
    var viewModel: ChooseQuestionViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.fetchData()
    }
}

// MARK: - Setup
extension ChooseQuestionViewController {
    private func setUp() {
        setUpNavigationBar()
        setUpCollectionView()
        setUpSubscriptions()
        setMultipleLargeTitle()
    }
    private func setUpNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: ChooseQuestionCollectionViewCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: ChooseQuestionCollectionViewCell.reuseIdentifier
        )
        collectionView.collectionViewLayout = .chooseQuestionLayout
    }
    
    private func setUpSubscriptions() {
        viewModel.reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
            .store(in: &subscriptions)
    }

    private func setMultipleLargeTitle() {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.edgesToSuperview(insets: .right(10))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = viewModel.header
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        navigationItem.titleView = view
    }
}

extension ChooseQuestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.questions?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChooseQuestionCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChooseQuestionCollectionViewCell else {
            fatalError("Cannot create the cell")
        }
        if let questions = viewModel.questions {
            cell.configure(questions: questions, index: indexPath.item)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ChooseQuestionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let questions = viewModel.questions else {return}
        coordinator?.goToTrainingViewController(
            questions: questions,
            selectedItem: indexPath.item,
            testMode: viewModel.testMode
        )
    }
}
