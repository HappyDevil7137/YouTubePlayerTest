//
//  NetworkController.swift
//  TestYouTubePlayer
//
//  Created by Golos on 23.05.2022.
//

import Foundation
import YoutubeKit

protocol NetworkControllerProtocol {
    func getPlaylistItems(playlistId: String, completion: @escaping (Result<PlaylistItemsList, Error>) -> Void)
    func getChannelItems(channelId: String, completion: @escaping (Result<ChannelList, Error>) -> Void)
}

struct NetworkController: NetworkControllerProtocol {
    var youTubeApi = YoutubeAPI.shared
    
    func getPlaylistItems(playlistId: String, completion: @escaping (Result<PlaylistItemsList, Error>) -> Void) {
        let request = PlaylistItemsListRequest(
            part: [.id, .contentDetails, .snippet, .status],
            filter: .playlistID(playlistId), maxResults: 10
        )
        
        youTubeApi.send(request, completion: completion)
    }
    
    func getChannelItems(channelId: String, completion: @escaping (Result<ChannelList, Error>) -> Void) {
        let request = ChannelListRequest(
            part: [.id, .contentDetails, .statistics, .snippet],
            filter: .id(channelId)
        )
        
        youTubeApi.send(request, completion: completion)
    }
}
