//
//  SceneDelegate.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit
import YoutubeKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var networkController = NetworkController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        YoutubeKit.shared.setAPIKey(APIRequest.key)
        window?.rootViewController = ControllersFactory.createYouTubeList(
            networkController: networkController,
            playListID: APIRequest.ffdpPlaylistId,
            channelD: APIRequest.bannerPlaylistsId
        )
        window?.makeKeyAndVisible()
    }
}

