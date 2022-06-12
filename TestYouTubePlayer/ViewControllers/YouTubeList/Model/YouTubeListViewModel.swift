//
//  YouTubeListViewModel.swift
//  TestYouTubePlayer
//
//  Created by Golos on 04.06.2022.
//

import UIKit
import YoutubeKit

protocol YouTubeListViewProtocol {
    var dataArray: [PlaylistItem] { get }
    
    var channelListHandler: ((ChannelList?) -> Void)? { get set }
    var reloadTableHandler: (() -> Void)? { get set }
    var selectionHandler: ((PlaylistItem, [PlaylistItem]) -> Void)?  { get set }
    
    func loadData()
    func loadChannelList()
}

final class YouTubeListViewModel: YouTubeListViewProtocol {
    private let networkController: NetworkControllerProtocol
    private let playListID: String
    private let channelD: String
    
    private(set) var dataArray = [PlaylistItem]()
    
    var channelListHandler: ((ChannelList?) -> Void)?
    var reloadTableHandler: (() -> Void)?
    var selectionHandler: ((PlaylistItem, [PlaylistItem]) -> Void)?
    
    init(networkController: NetworkControllerProtocol, playListID: String, channelD: String) {
        self.networkController = networkController
        self.playListID = playListID
        self.channelD = channelD
    }
    
    func loadData() {
        networkController.getPlaylistItems(playlistId: playListID) { [weak self] in
            switch $0 {
            case .success(let result):
                self?.dataArray += result.items
                DispatchQueue.main.async {
                    self?.reloadTableHandler?()
                }
            case .failure:
                break
            }
        }
    }
    
    func loadChannelList() {
        networkController.getChannelItems(channelId: APIRequest.bannerPlaylistsId) { [weak self] in
            switch $0 {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.channelListHandler?(result)
                }
            case .failure:
                break
            }
        }
    }
}

//MARK: - ViewLifecycleModel

extension YouTubeListViewModel: ViewLifecycleModel {
    func viewDidLoaded() {
        loadData()
        loadChannelList()
    }
}
