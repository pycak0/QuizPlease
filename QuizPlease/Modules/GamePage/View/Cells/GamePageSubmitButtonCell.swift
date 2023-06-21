//
//  GamePageSubmitButtonCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 25
    static let horizontalSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 16
}

/// GamePage submit button cell
final class GamePageSubmitButtonCell: UITableViewCell {

    private var tapAction: (() -> Void)?

    // MARK: - UI Elements

    private lazy var submitButton: BigButton = {
        let button = BigButton()
        button.backgroundColor = .lightGreen
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray6Adapted
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            submitButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            submitButton.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            submitButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    @objc
    private func buttonPressed() {
        tapAction?()
    }

    private func setButtonTitle(_ title: String, animated: Bool) {
        guard animated else {
            submitButton.setTitle(title, for: .normal)
            return
        }
        UIView.animate(withDuration: 0.1) { [self] in
            submitButton.alpha = 0.5
            submitButton.titleLabel?.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.1) { [self] in
                submitButton.alpha = 1
                submitButton.setTitle(title, for: .normal)
                submitButton.titleLabel?.alpha = 1
            }
        }
    }
}

// MARK: - GamePageCellProtocol

extension GamePageSubmitButtonCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageSubmitButtonItem else { return }
        let newTitle = item.getTitle()
        if newTitle != submitButton.title(for: .normal) {
            setButtonTitle(newTitle, animated: true)
        }
        tapAction = item.tapAction
    }
}
