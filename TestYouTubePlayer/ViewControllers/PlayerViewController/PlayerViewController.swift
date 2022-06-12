//
//  PlayerViewController.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit

final class PlayerViewController: UIViewController {
    private enum Constants {
        static let tintColor: String = "#FFFFFF"
        
        enum Backround {
            static let startGradientColor: CGColor = UIColor(hexValue: "#EE4289").cgColor
            static let endGradientColor: CGColor = UIColor(hexValue: "#630BF5").cgColor
        }
        
        enum Player {
            static let topOffset: CGFloat = 17
            static let bottomOffset: CGFloat = -20
        }
        
        enum Buttons {
            static let topOffset: CGFloat = 11
        }
        
        enum Sliders {
            static let minimumTintAlpha: CGFloat = 0.35
            static let videoSliderImage: UIImage? = UIImage(systemName: "poweron")
            static let videoSliderOffset: CGFloat = 15
            static let videoSliderCenterOffset: CGFloat = 18
            static let bottomOffset: CGFloat = -30
        }
        
        enum Labels {
            static let timeFont: UIFont = .systemFont(ofSize: 12)
            static let titleLabelFont: UIFont = .systemFont(ofSize: 18)
            static let viewsLabelFont: UIFont = .systemFont(ofSize: 16)
            static let textAlpha: CGFloat = 0.7
            static let labelLeadingOffset: CGFloat = 50
            static let titleTopOffset: CGFloat = 17
            static let viewsLabelTopOffset: CGFloat = 9
            static let videoLabelText: String = "0:00"
        }
        
        enum ImageName {
            static let prevButtonImage: UIImage? = UIImage(named: "Prev")
            static let pauseButoonImage: UIImage? = UIImage(named: "Pause")
            static let playButtonImage: UIImage? = UIImage(named: "Play")
            static let closeButtonImage: UIImage? = UIImage(named: "Close_Open")
            static let nextButtonImage: UIImage? = UIImage(named: "Next")
            static let lowVolumeImage: UIImage? = UIImage(named: "Sound_Min")
            static let hightVolumeImage: UIImage? = UIImage(named: "Sound_Max")
        }
        
        enum Stacks {
            static let topOffset: CGFloat = 40
            static let timeStackTopOffset: CGFloat = 7
            static let controlSpacing: CGFloat = 40
            static let volumeSpacing: CGFloat = 15
            static let controlStackLEadOffset: CGFloat = 90
        }
    }
    
    private let volumeSlider = UISlider()
    private let videoSlider = UISlider()
    private let startTimeLabel = UILabel()
    private let endTimeLabel = UILabel()
    private let videoTitleLabel = UILabel()
    private let viewsLabel = UILabel()
    private let lowVolumeImage = UIImageView()
    private let hightVolumeImage = UIImageView()
    private let previusButton = UIButton()
    private let pauseButton = UIButton()
    private let nextButton = UIButton()
    private let controlStackView = UIStackView()
    private let volumeControlStack = UIStackView()
    private let timeStackView = UIStackView()
    private let gradientLayer = CAGradientLayer()
    private lazy var closeButton = UIButton()
    
    var viewModel: PlayerViewProtocol?
    var lifeCycle: ViewLifecycleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupViews()
        setupHandler()
        lifeCycle?.viewDidLoaded()
    }
    
    private func setupGradient() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [Constants.Backround.startGradientColor, Constants.Backround.endGradientColor]
    }
    
    private func setupViews() {
        let arrayViews = [videoSlider, videoTitleLabel, viewsLabel, controlStackView, volumeControlStack, timeStackView, closeButton, viewModel?.playerView]
        view.addSubviews(arrayViews.compactMap { $0 })
        setupCloseButton()
        setupPlayer()
        setupVideoSlider()
        setupTimeStackView()
        setupTitleText()
        setupViewsText()
        setupControllStack()
        setupVolumeControlStack()
    }
    
    private func setupHandler() {
        viewModel?.playPauseButtonImage = { [weak self] in
            self?.pauseButton.setImage($0, for: .normal)
        }
        
        viewModel?.sliderValue = { [weak self] in
            self?.volumeSlider.value = $0
        }
        
        viewModel?.sliderMaxValue = { [weak self] in
            self?.volumeSlider.maximumValue = $0
        }
        
        viewModel?.startTimeText = { [weak self] in
            self?.startTimeLabel.text = $0
        }
        
        viewModel?.endTimeText = { [weak self] in
            self?.endTimeLabel.text = $0
        }
        
        viewModel?.maxDuration = { [weak self] in
            self?.videoSlider.maximumValue = $0
        }
        
        viewModel?.sliderPlayerValue = { [weak self] in
            self?.videoSlider.value = $0
        }
    }
    
    private func setupCloseButton() {
        closeButton.setImage(Constants.ImageName.closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(graberTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Buttons.topOffset)
        ])
    }
    
    @objc private func graberTapped() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseIn) { [weak self] in
            self?.closeButton.transform = CGAffineTransform(scaleX: 1, y: self?.viewModel?.bottomStateHandler?() == true ? 1 : -1)
        }
        viewModel?.moveHandler?()
    }
    
    @objc private func rewindVideo() {
        viewModel?.rewindVideo(to: videoSlider.value)
    }
    
    private func setupPlayer() {
        guard let youtubePlayer = viewModel?.playerView else { return }
        youtubePlayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            youtubePlayer.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.Player.topOffset),
            youtubePlayer.bottomAnchor.constraint(equalTo: videoSlider.topAnchor, constant: Constants.Player.bottomOffset),
            youtubePlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            youtubePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupVideoSlider() {
        videoSlider.translatesAutoresizingMaskIntoConstraints = false
        videoSlider.minimumTrackTintColor = UIColor(hexValue: Constants.tintColor)
        videoSlider.maximumTrackTintColor = UIColor(hexValue: Constants.tintColor, alpha: Constants.Sliders.minimumTintAlpha)
        videoSlider.setThumbImage(Constants.Sliders.videoSliderImage, for: .normal)
        videoSlider.addTarget(self, action: #selector(rewindVideo), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            videoSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Sliders.videoSliderOffset),
            videoSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Sliders.videoSliderOffset),
            videoSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.Sliders.videoSliderCenterOffset)
        ])
    }
    
    private func setupTimeStackView() {
        startTimeLabel.text = Constants.Labels.videoLabelText
        startTimeLabel.textColor = UIColor(hexValue: Constants.tintColor, alpha: Constants.Labels.textAlpha)
        startTimeLabel.font = Constants.Labels.timeFont
        
        endTimeLabel.text = Constants.Labels.videoLabelText
        endTimeLabel.textColor = UIColor(hexValue: Constants.tintColor, alpha: Constants.Labels.textAlpha)
        endTimeLabel.font = Constants.Labels.timeFont
        endTimeLabel.textAlignment = .right
        
        timeStackView.axis = .horizontal
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Sliders.videoSliderOffset),
            timeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Sliders.videoSliderOffset),
            timeStackView.topAnchor.constraint(equalTo: videoSlider.bottomAnchor, constant: Constants.Stacks.timeStackTopOffset)
        ])
    }
    
    private func setupTitleText() {
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        videoTitleLabel.textColor = UIColor(hexValue: Constants.tintColor)
        videoTitleLabel.font = Constants.Labels.titleLabelFont
        videoTitleLabel.textAlignment = .center
        
        viewModel?.titleLabelText = { [weak self] in
            self?.videoTitleLabel.text = $0
        }
        
        NSLayoutConstraint.activate([
            videoTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoTitleLabel.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: Constants.Labels.titleTopOffset),
            videoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Labels.labelLeadingOffset),
            videoTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Labels.labelLeadingOffset)
        ])
    }
    
    private func setupViewsText() {
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.textColor = UIColor(hexValue: Constants.tintColor, alpha: Constants.Labels.textAlpha)
        viewsLabel.font = Constants.Labels.viewsLabelFont
        viewsLabel.textAlignment = .center
        
        viewModel?.viewsLabelText = { [weak self] in
            self?.viewsLabel.text = $0
        }
        
        NSLayoutConstraint.activate([
            viewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewsLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: Constants.Labels.viewsLabelTopOffset),
            viewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Labels.labelLeadingOffset),
            viewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Labels.labelLeadingOffset)
        ])
    }
    
    private func setupControllStack() {
        controlStackView.axis = .horizontal
        controlStackView.spacing = Constants.Stacks.controlSpacing
        controlStackView.addArrangedSubview(previusButton)
        controlStackView.addArrangedSubview(pauseButton)
        controlStackView.addArrangedSubview(nextButton)
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        previusButton.setImage(Constants.ImageName.prevButtonImage, for: .normal)
        previusButton.addTarget(self, action: #selector(previousVideoTapped), for: .touchUpInside)
        
        pauseButton.setImage(Constants.ImageName.playButtonImage, for: .normal)
        pauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        
        nextButton.setImage(Constants.ImageName.nextButtonImage, for: .normal)
        nextButton.addTarget(self, action: #selector(nextVideoTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            controlStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlStackView.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: Constants.Stacks.topOffset)
        ])
    }
    
    @objc private func playPauseTapped() {
        viewModel?.playPauseTapped()
    }
    
    @objc private func previousVideoTapped() {
        viewModel?.previousVideoTapped()
    }
    
    @objc private func nextVideoTapped() {
        viewModel?.nextVideoTapped()
    }
    
    private func setupVolumeControlStack() {
        volumeControlStack.axis = .horizontal
        volumeControlStack.spacing = Constants.Stacks.volumeSpacing
        volumeControlStack.addArrangedSubview(lowVolumeImage)
        volumeControlStack.addArrangedSubview(volumeSlider)
        volumeControlStack.addArrangedSubview(hightVolumeImage)
        volumeControlStack.translatesAutoresizingMaskIntoConstraints = false
        
        lowVolumeImage.image = Constants.ImageName.lowVolumeImage
        hightVolumeImage.image = Constants.ImageName.hightVolumeImage
        
        volumeSlider.minimumTrackTintColor = UIColor(hexValue: Constants.tintColor)
        volumeSlider.maximumTrackTintColor = UIColor(hexValue: Constants.tintColor, alpha: Constants.Sliders.minimumTintAlpha)
        volumeSlider.value = 1
        volumeSlider.addTarget(self, action: #selector(volumeChanges), for: .touchUpInside)

        NSLayoutConstraint.activate([
            volumeControlStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            volumeControlStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Sliders.videoSliderOffset),
            volumeControlStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Sliders.videoSliderOffset),
            volumeControlStack.topAnchor.constraint(equalTo: controlStackView.bottomAnchor, constant: Constants.Stacks.topOffset),
            volumeControlStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.Sliders.bottomOffset)
        ])
    }
    
    @objc private func volumeChanges() {
        viewModel?.change(volume: volumeSlider.value)
    }
}
