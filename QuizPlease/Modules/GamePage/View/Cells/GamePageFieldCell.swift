//
//  GamePageFieldCell.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizontalSpacing: CGFloat = 16
    static let topInset: CGFloat = 10
}

/// GamePage cell with a text field
final class GamePageFieldCell: UITableViewCell {

    // MARK: - Private Properties

    private var onTextChange: ((String) -> Void)?

    // MARK: - Private Properties

    private var topInset: CGFloat = 10 {
        didSet { topConstraint.constant = topInset }
    }
    private var bottomInset: CGFloat = 0 {
        didSet { bottomConstraint.constant = -bottomInset }
    }

    private lazy var topConstraint: NSLayoutConstraint = {
        textFieldView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset)
    }()

    private lazy var bottomConstraint: NSLayoutConstraint = {
        textFieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomInset)
    }()

    // MARK: - UI Elements

    private lazy var textFieldView: PhoneTextFieldView = {
        let textFieldView = PhoneTextFieldView()
        textFieldView.delegate = self
        textFieldView.textField.returnKeyType = .done
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
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
        contentView.addSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            textFieldView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            topConstraint,
            bottomConstraint
        ])
    }
}

// MARK: - TitledTextFieldViewDelegate

extension GamePageFieldCell: TitledTextFieldViewDelegate {

    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String) {
        onTextChange?(text)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageFieldCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageFieldItem else { return }

        bottomInset = item.bottomInset

        textFieldView.isPhoneMaskEnabled = item.options.isPhoneMode

        textFieldView.title = item.title

        if !item.options.isPhoneMode {
            textFieldView.textField.placeholder = item.placeholder
        }

        textFieldView.backgroundColor = item.fieldColor
        backgroundColor = item.backgroundColor
        textFieldView.textField.textContentType = item.options.contentType
        textFieldView.textField.autocapitalizationType = item.options.capitalizationType
        textFieldView.textField.keyboardType = item.options.keyboardType

        onTextChange = item.onValueChange

        textFieldView.textField.text = item.valueProvider()
    }
}
