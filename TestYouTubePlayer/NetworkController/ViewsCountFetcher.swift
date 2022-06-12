//
//  ViewsCountFetcher.swift
//  TestYouTubePlayer
//
//  Created by Golos on 23.05.2022.
//

import Foundation
import YoutubeKit

struct ViewsCountFetcher {
    
    var source = YoutubeAPI.shared
    
    func getViewsCount(with id: String, completion: @escaping (String) -> Void) {
        
        let request = VideoListRequest(part: [.statistics], filter: .id(id))
        source.send(request) { result in
            switch result {
            case .success(let response):
                if let viewCount = response.items.first?.statistics?.viewCount {
                    completion(String(format: NSLocalizedString("%ld просмотров", comment: ""), Int(viewCount) ?? 0))
                } else {
                    completion("-")
                }
            case .failure:
                completion("-")
            }
        }
    }
}
