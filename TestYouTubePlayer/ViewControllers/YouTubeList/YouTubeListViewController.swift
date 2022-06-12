//
//  YouTubeListViewController.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit
import FloatingPanel

final class YouTubeListViewController: UIViewController, FloatingPanelControllerDelegate {
    private enum Constants {
        static let viewBackground = UIColor(hexValue: "#1f1726")
        static let sectionTextColor: UIColor = .white
        static let sectionFont: UIFont = .systemFont(ofSize: 23, weight: .semibold)
        static let leadingOffset: CGFloat = 18
        static let topOffset: CGFloat = 30
        static let bannerHeightOffset: CGFloat = 180
        static let sectionCount: Int = 1
    }
    
    private let youTubeTableView = UITableView(frame: .zero, style: .plain)
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let stackView = UIStackView()
    
    var viewModel: YouTubeListViewProtocol?
    var lifeCycle: ViewLifecycleModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.viewBackground
        setupTableView()
        setupScrollView()
        setupStackView()
        setupPageControll()
        viewModel?.reloadTableHandler = { [weak self] in
            self?.youTubeTableView.reloadData()
        }
        viewModel?.channelListHandler = { [weak self] in
            self?.pageControl.numberOfPages = $0?.items.count ?? 0
            
            $0?.items.forEach {
                let subView = BannerView()
                
                subView.channelTitle = $0.snippet?.title
                subView.subscribers = String(
                    format: NSLocalizedString("%ld подписчиков", comment: ""),
                    Int($0.statistics?.subscriberCount ?? "") ?? 0
                )
                subView.imageURL = URL(string: $0.snippet?.thumbnails.medium.url ?? "")
                subView.translatesAutoresizingMaskIntoConstraints = false
                
                self?.stackView.addArrangedSubview(subView)
                self?.scrollView.widthAnchor.constraint(equalTo: subView.widthAnchor).isActive = true
            }
        }
        lifeCycle?.viewDidLoaded()
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingOffset),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.leadingOffset),
            scrollView.heightAnchor.constraint(equalToConstant: Constants.bannerHeightOffset)
        ])
    }
    
    private func setupPageControll() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = .zero
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageControl.bottomAnchor.constraint(equalTo: youTubeTableView.topAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(youTubeTableView)
        youTubeTableView.registerCell(YouTubeTableViewCell.self)
        youTubeTableView.delegate = self
        youTubeTableView.dataSource = self
        youTubeTableView.backgroundColor = .clear
        youTubeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            youTubeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            youTubeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingOffset),
            youTubeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension YouTubeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = Constants.sectionFont
        header?.textLabel?.textColor = Constants.sectionTextColor
        header?.setNeedsLayout()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let result = viewModel?.dataArray.element(at: section) else { return .init() }
        return result.snippet.channelTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YouTubeTableViewCell = youTubeTableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = viewModel
        return cell
    }
}

//MARK: - UIScrollViewDelegate

extension YouTubeListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
