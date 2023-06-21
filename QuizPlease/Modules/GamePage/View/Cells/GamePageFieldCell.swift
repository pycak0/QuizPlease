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
    static let buttonInset: CGFloat = 8
}

/// GamePage cell with a text field
final class GamePageFieldCell: UITableViewCell {

    // MARK: - Private Properties

    private var trimsUserInput = true
    private var buttonTapAction: (() -> Void)?
    private var onTextChange: ((String) -> Void)?
    private var onEndEditing: (() -> Void)?

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
        textFieldView.formattingKind = .internationalWithMask
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()

    private lazy var accessoryButton: ScalingButton = {
        let button = ScalingButton()
        button.backgroundColor = .lightGreen
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .gilroy(.semibold, size: 16)
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        return textFieldView.becomeFirstResponder()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(textFieldView)
        contentView.addSubview(accessoryButton)
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            textFieldView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            topConstraint,
            bottomConstraint,

            accessoryButton.trailingAnchor.constraint(
                equalTo: textFieldView.trailingAnchor, constant: -Constants.buttonInset),
            accessoryButton.topAnchor.constraint(
                equalTo: textFieldView.topAnchor, constant: Constants.buttonInset),
            accessoryButton.bottomAnchor.constraint(
                equalTo: textFieldView.bottomAnchor, constant: -Constants.buttonInset),
            accessoryButton.widthAnchor.constraint(
                equalTo: accessoryButton.heightAnchor)
        ])
    }

    @objc
    private func buttonPressed() {
        buttonTapAction?()
    }
}

// MARK: - TitledTextFieldViewDelegate

extension GamePageFieldCell: TitledTextFieldViewDelegate {

    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String) {
        onTextChange?(text)
    }

    func textFieldViewDidEndEditing(_ textFieldView: TitledTextFieldView) {
        if trimsUserInput {
            let text = self.textFieldView.isPhoneMaskEnabled
                ? self.textFieldView.extractedFormattedNumber
                : (self.textFieldView.textField.text ?? "")
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            textFieldView.textField.text = trimmedText
            onTextChange?(trimmedText)
        }
        onEndEditing?()
    }
}

// MARK: - GamePageCellProtocol

extension GamePageFieldCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageFieldItem else { return }

        trimsUserInput = item.trimsUserInput
        bottomInset = item.bottomInset

        textFieldView.isPhoneMaskEnabled = item.options.isPhoneMode

        textFieldView.title = item.title

        if !item.options.isPhoneMode {
            textFieldView.textField.placeholder = item.placeholder
        }

        textFieldView.backgroundColor = item.fieldColor
        contentView.backgroundColor = item.backgroundColor
        textFieldView.textField.textContentType = item.options.contentType
        textFieldView.textField.autocapitalizationType = item.options.capitalizationType
        textFieldView.textField.keyboardType = item.options.keyboardType

        onTextChange = item.onValueChange
        onEndEditing = item.onEndEditing

        textFieldView.textField.text = item.valueProvider()

        accessoryButton.isHidden = !item.showsOkButton
        buttonTapAction = item.okButtonAction
    }
}
