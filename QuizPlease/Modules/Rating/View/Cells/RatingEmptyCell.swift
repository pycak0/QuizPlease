//
//  RatingEmptyCell.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 120
    static let horizontalSpacing: CGFloat = 36
    static let bottomSpacing: CGFloat = 30
    static let titleToImageSpacing: CGFloat = 50
}

/// Rating cell supposed to be presented when the list is empty
final class RatingEmptyCell: UITableViewCell {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .gilroy(.bold, size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

    override func layoutSubviews() {
        super.layoutSubviews()
        hideSeparator()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.titleToImageSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            titleLabel,
            emptyImageView
        ].forEach(stackView.addArrangedSubview(_:))

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    private func hideSeparator() {
        for view in subviews where type(of: view).description() == "_UITableViewCellSeparatorView" {
            view.isHidden = true
            break
        }
    }
}

// MARK: - RatingCell

extension RatingEmptyCell: RatingCell {

    func configure(with item: RatingItem) {
        guard let item = item as? RatingEmptyItem else { return }
        titleLabel.text = item.title
        emptyImageView.image = UIImage(named: item.imageName)
    }
}
