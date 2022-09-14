//
//  OnboardingView.swift
//  QuizPlease
//
//  Created by Владислав on 13.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

protocol OnboardingViewDelegate: AnyObject {

    func didSelectPage(at pageIndex: Int)
}

final class OnboardingView: UIView {

    weak var delegate: OnboardingViewDelegate?

    // MARK: - State Properties

    var items: [OnboardingPageViewModel] = [] {
        didSet {
            reloadData()
        }
    }

    var isPageControlEnabled: Bool {
        get { pageControl.isUserInteractionEnabled }
        set { pageControl.isUserInteractionEnabled = newValue }
    }

    var selectedPageIndex: Int {
        get { primaryVisiblePage }
        set { setPage(index: newValue) }
    }

    // MARK: - Private Properties

    private let pageSpacing: CGFloat

    private var primaryVisiblePage: Int {
        let width = collectionView.frame.width
        return width > 0 ? Int(collectionView.contentOffset.x + width / 2) / Int(width) : 0
    }

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.register(OnboardingViewCell.self, forCellWithReuseIdentifier: "\(OnboardingViewCell.self)")
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.clipsToBounds = false
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = pageSpacing
        layout.minimumInteritemSpacing = pageSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: pageSpacing / 2, bottom: 0, right: pageSpacing / 2)
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageConrolChanged), for: .valueChanged)
        return pageControl
    }()

    // MARK: - Lifecycle

    init(pageSpacing: CGFloat) {
        self.pageSpacing = pageSpacing
        super.init(frame: .zero)
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLayout() {
        addSubview(collectionView)
        addSubview(pageControl)
        let inset = -1 * pageSpacing / 2
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func showNextPage() {
        setPage(index: primaryVisiblePage + 1)
    }

    func showPreviousPage() {
        setPage(index: primaryVisiblePage - 1)
    }

    // MARK: - Private Methods

    private func reloadData() {
        collectionView.reloadData()
        pageControl.numberOfPages = items.count
    }

    @objc
    private func pageConrolChanged() {
        let page = pageControl.currentPage
        setPage(index: page)
    }

    private func setPage(index: Int) {
        guard
            index >= 0,
            index < items.count
        else { return }

        let offset = (bounds.width + pageSpacing) * CGFloat(index)
        collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

        if pageControl.currentPage != index {
            setPageControlPage(index: index)
        }
    }

    private func setPageControlPage(index: Int) {
        pageControl.currentPage = index
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(OnboardingViewCell.self, for: indexPath)
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingView: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPageIndex = primaryVisiblePage
        pageControl.currentPage = currentPageIndex
        delegate?.didSelectPage(at: currentPageIndex)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: bounds.width, height: collectionView.bounds.height)
    }
}
