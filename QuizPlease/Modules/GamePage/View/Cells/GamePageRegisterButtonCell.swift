//
//  GamePageRegisterButtonCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 8
    static let bottomSpacing: CGFloat = 10
    static let height: CGFloat = 40
    static let widthFraction: CGFloat = 2 / 3
}

/// GamePage cell with register button
final class GamePageRegisterButtonCell: UITableViewCell {

    private var tapHandler: (() -> Void)?

    // MARK: - UI Elements

    private lazy var registerButton: ScalingButton = {
        let button = ScalingButton()
        button.backgroundColor = .lightGreen
        button.titleLabel?.font = .gilroy(.bold, size: 16)
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalToConstant: Constants.height),
            registerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topSpacing),
            registerButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.bottomSpacing),
            registerButton.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: Constants.widthFraction)
        ])
    }

    @objc private func registerButtonPressed() {
        tapHandler?()
    }
}

// MARK: - GamePageCellProtocol

extension GamePageRegisterButtonCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageRegisterButtonItem else { return }
        registerButton.setTitle(item.title, for: .normal)
        registerButton.backgroundColor = item.color
        registerButton.isEnabled = item.isEnabled
        tapHandler = item.tapAction
    }
}
