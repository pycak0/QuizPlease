//
//  GamePageTextCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizontalSpacing: CGFloat = 16
}

/// GamePage title cell
final class GamePageTextCell: UITableViewCell {

    // MARK: - Private Properties

    private var topInset: CGFloat = 16 {
        didSet { topConstraint.constant = topInset }
    }
    private var bottomInset: CGFloat = 16 {
        didSet { bottomConstraint.constant = -bottomInset }
    }

    private lazy var topConstraint: NSLayoutConstraint = {
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset)
    }()

    private lazy var bottomConstraint: NSLayoutConstraint = {
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomInset)
    }()

    // MARK: - UI Elements

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
//        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            label.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            label.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing)
        ])
    }
}

// MARK: - GamePageCellProtocol

extension GamePageTextCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageTextItem else { return }
        label.text = item.text
        label.font = item.style.font
        label.textColor = item.style.color
        topInset = item.topInset
        bottomInset = item.bottomInset
    }
}
