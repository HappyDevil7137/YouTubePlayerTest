//
//  YouTubeTableViewCell.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit

final class YouTubeTableViewCell: UITableViewCell {
    private enum Constants {
        static let backgroundColor: UIColor = .clear
        static let heightOffset: CGFloat = 200
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .gridLayout)
    private var viewsCountFetcher = ViewsCountFetcher()
    
    var viewModel: YouTubeListViewProtocol? {
        didSet {
            viewModel?.reloadTableHandler = { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        backgroundColor = Constants.backgroundColor
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Constants.backgroundColor
        collectionView.registerCell(ItemCollectionViewCell.self)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.heightOffset)
        ])
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension YouTubeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dataArray.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let result = viewModel?.dataArray.element(at: indexPath.row) else { return .init() }
        cell.playListItem = result
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let result = viewModel?.dataArray.element(at: indexPath.row) else { return }
        viewModel?.selectionHandler?(result, viewModel?.dataArray ?? [])
    }
}
