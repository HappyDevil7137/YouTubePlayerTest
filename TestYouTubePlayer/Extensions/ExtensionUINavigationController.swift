//
//  ExtensionUINavigationController.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//
import UIKit

private enum StyleConstants {
    static let backgroundColor: UIColor = UIColor(hexValue: "#1f1726")
    static let tintColor: UIColor = .white
}

extension UINavigationController {
    
    func setupNavigationBarCustomStyle() {
        
        let navigationColoredAppearance = UINavigationBarAppearance()
        navigationColoredAppearance.configureWithTransparentBackground()
        navigationColoredAppearance.titleTextAttributes = [.foregroundColor: StyleConstants.tintColor]
        navigationColoredAppearance.largeTitleTextAttributes = [.foregroundColor: StyleConstants.tintColor]
        navigationColoredAppearance.backgroundColor = StyleConstants.backgroundColor
        
        UINavigationBar.appearance().compactAppearance = navigationColoredAppearance
        UINavigationBar.appearance().standardAppearance = navigationColoredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationColoredAppearance
    }
}
