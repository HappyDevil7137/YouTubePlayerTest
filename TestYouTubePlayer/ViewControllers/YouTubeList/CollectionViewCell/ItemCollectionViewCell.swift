//
//  ItemCollectionViewCell.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit
import Kingfisher
import YoutubeKit

final class ItemCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let defaultOffset: CGFloat = 2
        static let imageBottomOffset: CGFloat = -8
        static let imageSize: CGFloat = 135
        static let titleBottomOffset: CGFloat = -4
        static let imageCornerRadius: CGFloat = 6
        static let titleTextColor: UIColor = UIColor(hexValue: "#FFFFFF")
        static let viewsTextColor: UIColor = UIColor(hexValue: "#979797")
        static let titleFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        static let viewsFont: UIFont = .systemFont(ofSize: 12)
    }
    
    private var previewImage = UIImageView()
    private var titleLabel = UILabel()
    private var viewsLabel = UILabel()
    private let viewsCountFetcher = ViewsCountFetcher()
    
    var playListItem: PlaylistItem? {
        didSet {
            previewImage.kf.setImage(with: URL(string: playListItem?.snippet.thumbnails.medium.url ?? ""))
            titleLabel.text = playListItem?.snippet.title
            viewsCountFetcher.getViewsCount(with: playListItem?.contentDetails.videoID ?? "") { [weak self] in
                self?.viewsLabel.text = $0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([previewImage, titleLabel, viewsLabel])
        setupPreviewImage()
        setupTitle()
        setupViewsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPreviewImage() {
        previewImage.contentMode = .scaleAspectFill
        previewImage.layer.cornerRadius = Constants.imageCornerRadius
        previewImage.clipsToBounds = true
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultOffset),
            previewImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: Constants.imageBottomOffset),
            previewImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            previewImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            previewImage.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }
    
    private func setupTitle() {
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultOffset),
            titleLabel.bottomAnchor.constraint(equalTo: viewsLabel.topAnchor, constant: Constants.titleBottomOffset)
        ])
    }
    
    private func setupViewsLabel() {
        viewsLabel.font = Constants.viewsFont
        viewsLabel.textColor = Constants.viewsTextColor
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultOffset),
            viewsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultOffset),
            viewsLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -Constants.defaultOffset)
        ])
    }
}
