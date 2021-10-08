//
//  UICollectionViewLayout+mainMenuLayout.swift
//  wheels_Andrew
//
//  Created by Andrew on 21.07.21.
//

import UIKit

extension UICollectionViewLayout {
    static var mainMenuLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 30
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalWidth(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 20
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                ),
                elementKind: HeaderView.reuseIdentifier,
                alignment: .top
            )
        ]
        section.contentInsets.trailing = 15
        return UICollectionViewCompositionalLayout(section: section)
    }
}
