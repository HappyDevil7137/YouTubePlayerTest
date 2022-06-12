//
//  ControllersFactory.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit
import FloatingPanel

struct ControllersFactory {
    private enum Constants {
        static let viewControllerTitle = "YouTubeAPI"
    }
    
    static func createYouTubeList(networkController: NetworkControllerProtocol, playListID: String, channelD: String) -> UIViewController {
        let viewController = YouTubeListViewController()
        let playerVC = PlayerViewController()
        let youTubeListNavigationVC = UINavigationController(rootViewController: viewController)
        let fpc = FloatingPanelController()
        let youTubeListViewModel = YouTubeListViewModel(
            networkController: networkController,
            playListID: playListID,
            channelD: channelD
        )
        let playerViewModel = PlayerViewModel()
        
        viewController.viewModel = youTubeListViewModel
        viewController.lifeCycle = youTubeListViewModel
        
        playerVC.viewModel = playerViewModel
        playerVC.lifeCycle = playerViewModel
        
        fpc.setupFloatingPanel(parentVC: viewController, contentViewController: playerVC)
        
        playerViewModel.moveHandler = { [weak fpc] in
            fpc?.move(to: fpc?.state == .full ? .tip : .full, animated: true)
        }
        playerViewModel.bottomStateHandler = { [weak fpc] in
            fpc?.state == .full
        }
        viewController.viewModel?.selectionHandler = {
            playerViewModel.videoId = $0.contentDetails.videoID
            playerViewModel.titleLabelText?($0.snippet.title)
            playerViewModel.videoTitles = $1.map { $0.snippet.title }
            playerViewModel.playlistVideoIds = $1.map { $0.contentDetails.videoID }
            playerViewModel.moveHandler?()
        }
        
        youTubeListNavigationVC.navigationBar.prefersLargeTitles = true
        youTubeListNavigationVC.setupNavigationBarCustomStyle()
        viewController.title = Constants.viewControllerTitle
        return youTubeListNavigationVC
    }
}
