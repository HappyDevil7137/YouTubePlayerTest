//
//  FloatingPanelController+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 20.05.2022.
//

import UIKit
import FloatingPanel

private enum Constants {
    static let cornerRadius: CGFloat = 15
    static let fullInset: CGFloat = 16
    static let tipInset: CGFloat = 15
}

extension FloatingPanelController {
    func setupFloatingPanel(parentVC: FloatingPanelControllerDelegate & UIViewController, contentViewController: UIViewController) {
        let appearance = SurfaceAppearance()
        
        appearance.cornerRadius = Constants.cornerRadius
        surfaceView.appearance = appearance
        surfaceView.grabberHandle.isHidden = true
        delegate = parentVC
        layout = MyFloatingPanelLayout()
        set(contentViewController: contentViewController)
        addPanel(toParent: parentVC)
    }
}

final class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: Constants.fullInset, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: Constants.tipInset, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
