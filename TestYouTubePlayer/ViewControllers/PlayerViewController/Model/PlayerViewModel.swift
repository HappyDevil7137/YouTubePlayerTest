//
//  PlayerViewModel.swift
//  TestYouTubePlayer
//
//  Created by Golos on 04.06.2022.
//

import UIKit
import YoutubeKit

protocol PlayerViewProtocol {
    var videoTitles: [String] { get }
    var videoCounter: Int { get }
    var playlistVideoIds: [String] { get }
    var playerView: UIView { get }
    
    var moveHandler: (() -> Void)? { get set }
    var bottomStateHandler: (() -> Bool)? { get set }
    var titleLabelText: ((String) -> Void)? { get set }
    var viewsLabelText: ((String) -> Void)? { get set }
    var playPauseButtonImage: ((UIImage?) -> Void)? { get set }
    var sliderValue: ((Float) -> Void)? { get set }
    var startTimeText: ((String) -> Void)? { get set }
    var endTimeText: ((String) -> Void)? { get set }
    var sliderMaxValue: ((Float) -> Void)? { get set }
    var maxDuration: ((Float) -> Void)? { get set }
    var sliderPlayerValue: ((Float) -> Void)? { get set }
    
    func previousVideoTapped()
    func nextVideoTapped()
    func playPauseTapped()
    func change(volume: Float)
    func rewindVideo(to seconds: Float)
}

final class PlayerViewModel: PlayerViewProtocol {
    private enum Constants {
        static let pauseButoonImage: UIImage? = UIImage(named: "Pause")
        static let playButtonImage: UIImage? = UIImage(named: "Play")
    }
    
    private let viewsCountFetcher: ViewsCountFetcher
    private lazy var youtubePlayer = YTSwiftyPlayer()
    
    var playerView: UIView {
        youtubePlayer
    }
    
    var videoTitles: [String] = []
    var videoCounter = 0
    var playlistVideoIds: [String] = []
    
    var videoId = "" {
        didSet {
            guard let path = Bundle.main.path(forResource: "player", ofType: "html"),
                  let html = try? String(contentsOfFile: path, encoding: .utf8) else { return }
            youtubePlayer.setPlayerParameters([.videoID(videoId), .playsInline(true), .showRelatedVideo(false), .showModestbranding(true), .showLoadPolicy(false), .showInfo(false), .showControls(.hidden)])
            youtubePlayer.loadPlayerHTML(html)
        }
    }
    
    var moveHandler: (() -> Void)?
    var bottomStateHandler: (() -> Bool)?
    var titleLabelText: ((String) -> Void)?
    var viewsLabelText: ((String) -> Void)?
    var playPauseButtonImage: ((UIImage?) -> Void)?
    var sliderValue: ((Float) -> Void)?
    var startTimeText: ((String) -> Void)?
    var endTimeText: ((String) -> Void)?
    var sliderMaxValue: ((Float) -> Void)?
    var maxDuration: ((Float) -> Void)?
    var sliderPlayerValue: ((Float) -> Void)?
    
    init(viewsCountFetcher: ViewsCountFetcher = .init()) {
        self.viewsCountFetcher = viewsCountFetcher
    }
    
    func previousVideoTapped() {
        guard let startIndex = playlistVideoIds.firstIndex(of: videoId) else { return }
        
        if youtubePlayer.currentPlaylist.isEmpty {
            youtubePlayer.loadPlaylist(
                playlist: playlistVideoIds,
                startIndex: startIndex - 1,
                startSeconds: 0,
                suggestedQuality: .large
            )
            youtubePlayer.playVideo()
            
            if videoCounter > 0 {
                videoCounter -= 1
            }
            
            viewsCountFetcher.getViewsCount(with: playlistVideoIds[videoCounter]) { [weak self] in
                self?.viewsLabelText?($0)
            }
            titleLabelText?(videoTitles[videoCounter])
        } else {
            if videoCounter > 0 {
                videoCounter -= 1
                viewsCountFetcher.getViewsCount(with: playlistVideoIds[videoCounter]) { [weak self] in
                    self?.viewsLabelText?($0)
                }
            }
            
            youtubePlayer.previousVideo()
            titleLabelText?(videoTitles[videoCounter])
        }
    }
    
    func nextVideoTapped() {
        guard let startIndex = playlistVideoIds.firstIndex(of: videoId) else { return }
        
        if youtubePlayer.currentPlaylist.isEmpty {
            youtubePlayer.loadPlaylist(
                playlist: playlistVideoIds,
                startIndex: startIndex + 1,
                startSeconds: 0,
                suggestedQuality: .large
            )
            youtubePlayer.playVideo()
            if videoCounter < 9 {
                videoCounter += 1
                viewsCountFetcher.getViewsCount(with: playlistVideoIds[videoCounter]) { [weak self] in
                    self?.viewsLabelText?($0)
                }
            }
            titleLabelText?(videoTitles[videoCounter])
        } else {
            youtubePlayer.nextVideo()
            if videoCounter < 9 {
                videoCounter += 1
                viewsCountFetcher.getViewsCount(with: playlistVideoIds[videoCounter]) { [weak self] in
                    self?.viewsLabelText?($0)
                }
            }
            titleLabelText?(videoTitles[videoCounter])
        }
    }
    
    func playPauseTapped() {
        if youtubePlayer.playerState == .playing {
            youtubePlayer.pauseVideo()
            playPauseButtonImage?(Constants.playButtonImage)
        } else {
            youtubePlayer.playVideo()
            playPauseButtonImage?(Constants.pauseButoonImage)
        }
    }
    
    func change(volume: Float) {
        if volume <= 0.5 {
            sliderValue?(0)
            youtubePlayer.mute()
        } else  {
            sliderValue?(1)
            youtubePlayer.unMute()
        }
    }
    
    func rewindVideo(to seconds: Float) {
        if let duration = youtubePlayer.duration {
            maxDuration?(Float(duration))
        }
        youtubePlayer.seek(to: Int(seconds), allowSeekAhead: true)
    }
}

//MARK: - ViewLifecycleModel

extension PlayerViewModel: ViewLifecycleModel {
    func viewDidLoaded() {
        youtubePlayer.delegate = self
    }
}

//MARK: - YTSwiftyPlayerDelegate

extension PlayerViewModel: YTSwiftyPlayerDelegate {
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        let curMinutes = Int(floor(currentTime / 60))
        let curSeconds = Int(currentTime) - curMinutes * 60
        startTimeText?(String(format: NSLocalizedString("%02d:%02d", comment: ""), curMinutes, curSeconds))
        sliderPlayerValue?(Float(currentTime))
        
        if let duration = player.duration {
            let durMinutes = Int(floor(duration / 60))
            let durSeconds = Int(duration) - durMinutes * 60
            endTimeText?(String(format: NSLocalizedString("%02d:%02d", comment: ""), durMinutes, durSeconds))
            maxDuration?(Float(duration))
        }
    }
    
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        if state == .paused {
            playPauseButtonImage?(Constants.playButtonImage)
        } else if state == .playing {
            playPauseButtonImage?(Constants.pauseButoonImage)
        }
    }
}
