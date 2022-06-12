//
//  UICollectionView+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
