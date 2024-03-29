//
//  GamePageInfoLineView.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    /// spacing between icon and text
    static let horizontalSpacing: CGFloat = 8
    static let iconWidth: CGFloat = 20
}

/// A line of information of the game
final class GamePageInfoLineView: UIView {

    // MARK: - UI Elements

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5Adapted
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.bold, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.bold, size: 12)
        label.textColor = .placeholderTextAdapted
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    convenience init(viewModel: GamePageInfoLineViewModel) {
        self.init()
        setViewModel(viewModel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func setViewModel(_ viewModel: GamePageInfoLineViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title == nil

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil

        iconImageView.image = viewModel.iconName.map { UIImage(named: $0) } ?? nil
        iconImageView.isHidden = viewModel.iconName == nil
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        [
            titleLabel,
            subtitleLabel
        ].forEach(verticalStack.addArrangedSubview(_:))

        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = Constants.horizontalSpacing
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        [
            iconImageView,
            verticalStack
        ].forEach(horizontalStack.addArrangedSubview(_:))

        addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconWidth),

            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
