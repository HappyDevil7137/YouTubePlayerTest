//
//  BannerView.swift
//  TestYouTubePlayer
//
//  Created by Golos on 31.05.2022.
//

import UIKit
import Kingfisher

final class BannerView: UIView {
    private enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let leadingOffset: CGFloat = 10
        static let badgeSize: CGFloat = 50
        static let channelTitleBottomOffset: CGFloat = -4
        static let subscribersBottonOffset: CGFloat = -15
        static let channelTitleFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
        static let subscribersFont: UIFont = .systemFont(ofSize: 16)
        static let channelLabelTextColor: UIColor = UIColor(hexValue: "#383838")
        static let subscribersLabelColor: UIColor = UIColor(hexValue: "#9D9D9D")
        static let startGradientColor: CGColor = UIColor(hexValue: "#EE4289").cgColor
        static let endGradientColor: CGColor = UIColor(hexValue: "#630BF5").cgColor
        static let playImage: UIImage? = UIImage(named: "Play")
    }
    
    private let imageView: UIImageView = UIImageView()
    private let channelLabel: UILabel = UILabel()
    private let subscribersLabel: UILabel = UILabel()
    private let badgeView: UIView = UIView()
    
    var imageURL: URL? {
        didSet {
            imageView.kf.setImage(with: imageURL)
        }
    }
    var channelTitle: String? {
        didSet {
            channelLabel.text = channelTitle
        }
    }
    var subscribers: String? {
        didSet {
            subscribersLabel.text = subscribers
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews([imageView, channelLabel, subscribersLabel, badgeView])
        setupImageView()
        setupUIView()
        setupChannelLabel()
        setupSubscribersLabel()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupUIView() {
        let gradientLayer = CAGradientLayer()
        let uiImageView = UIImageView()
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: Constants.badgeSize, height: Constants.badgeSize)
        gradientLayer.colors = [Constants.startGradientColor, Constants.endGradientColor]
        gradientLayer.cornerRadius = Constants.badgeSize / 2
        badgeView.layer.addSublayer(gradientLayer)
        badgeView.addSubview(uiImageView)
        uiImageView.image = Constants.playImage
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.leadingOffset),
            badgeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingOffset),
            badgeView.widthAnchor.constraint(equalToConstant: Constants.badgeSize),
            badgeView.heightAnchor.constraint(equalToConstant: Constants.badgeSize),
            uiImageView.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            uiImageView.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor)
        ])
    }
    
    private func setupChannelLabel() {
        channelLabel.translatesAutoresizingMaskIntoConstraints = false
        channelLabel.font = Constants.channelTitleFont
        channelLabel.textColor = Constants.channelLabelTextColor
        
        NSLayoutConstraint.activate([
            channelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingOffset),
            channelLabel.bottomAnchor.constraint(equalTo: subscribersLabel.topAnchor, constant: Constants.channelTitleBottomOffset),
            channelLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Constants.leadingOffset)
        ])
    }
    
    private func setupSubscribersLabel() {
        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribersLabel.font = Constants.subscribersFont
        subscribersLabel.textColor = Constants.subscribersLabelColor
        
        NSLayoutConstraint.activate([
            subscribersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingOffset),
            subscribersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.subscribersBottonOffset),
        ])
    }
}
