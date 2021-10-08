//
//  UICollectionViewLayout+ruleUnitLayout.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import UIKit

extension UICollectionViewLayout {
    static var ruleUnitLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}
