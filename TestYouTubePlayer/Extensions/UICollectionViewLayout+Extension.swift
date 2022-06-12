//
//  UICollectionViewLayout+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit

extension UICollectionViewLayout {
    private enum Constants {
        static let indents: CGFloat = 10
        static let itemIndents: CGFloat = 10
        static let columsCount: Int = 1
        static let fractionalWidth: CGFloat = 0.40
        static let sectionFractionalHeight: CGFloat = 0.25
    }
    
    static var gridLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(160),
            heightDimension: .estimated(160)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.itemIndents,
            leading: Constants.itemIndents,
            bottom: Constants.itemIndents,
            trailing: Constants.itemIndents
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitem: item,
            count: Constants.columsCount
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.indents,
            leading: Constants.indents,
            bottom: Constants.indents,
            trailing: Constants.indents
        )
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
