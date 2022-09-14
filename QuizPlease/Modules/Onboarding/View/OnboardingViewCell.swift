//
//  OnboardingViewCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

final class OnboardingViewCell: UICollectionViewCell {

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        imageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .gilroy(.bold, size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .gilroy(.medium, size: 16)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLayout() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        [
            imageView,
            titleLabel,
            subtitleLabel
        ].forEach(verticalStack.addArrangedSubview(_:))

        contentView.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with model: OnboardingPageViewModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
