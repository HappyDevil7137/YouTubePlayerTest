//
//  UIView+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit

extension UIView {
    
    static var nibName: String {
        "\(self)".components(separatedBy: ".").first ?? ""
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
