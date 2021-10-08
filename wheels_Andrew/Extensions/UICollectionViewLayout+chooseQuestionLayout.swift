//
//  UICollectionViewLayout+chooseQuestionLayout.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import UIKit

extension UICollectionViewLayout {
    static var chooseQuestionLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}
