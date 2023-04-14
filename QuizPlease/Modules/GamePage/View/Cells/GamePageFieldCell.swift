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

    private var onTextChange: ((String) -> Void)?

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
            textFieldView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topInset),
            textFieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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

        textFieldView.isPhoneMaskEnabled = item.options.isPhoneMode

        textFieldView.title = item.title

        if !item.options.isPhoneMode {
            textFieldView.textField.placeholder = item.placeholder
        }

        textFieldView.textField.textContentType = item.options.contentType
        textFieldView.textField.autocapitalizationType = item.options.capitalizationType
        textFieldView.textField.keyboardType = item.options.keyboardType

        onTextChange = item.onValueChange

        textFieldView.textField.text = item.valueProvider()
    }
}
