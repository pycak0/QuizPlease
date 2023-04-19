//
//  GamePageMultilineFieldCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizontalSpacing: CGFloat = 16
    static let topInset: CGFloat = 10
    static let buttonInset: CGFloat = 8
}

/// GamePage cell with a text field
final class GamePageMultilineFieldCell: UITableViewCell {

    // MARK: - Private Properties

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

    private lazy var textFieldView: TitledTextView = {
        let textFieldView = TitledTextView()
        textFieldView.delegate = self
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
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

extension GamePageMultilineFieldCell: TitledTextViewDelegate {

    func textView(_ textView: TitledTextView, didChangeText text: String) {
        onTextChange?(text)
    }

    func textViewDidEndEditing(_ textView: TitledTextView) {
        onEndEditing?()
    }
}

// MARK: - GamePageCellProtocol

extension GamePageMultilineFieldCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageMultilineFieldItem else { return }

        bottomInset = item.bottomInset

        textFieldView.title = item.title
        textFieldView.placeholder = item.placeholder

        textFieldView.backgroundColor = item.fieldColor
        contentView.backgroundColor = item.backgroundColor
        textFieldView.textView.textContentType = item.options.contentType
        textFieldView.textView.autocapitalizationType = item.options.capitalizationType
        textFieldView.textView.keyboardType = item.options.keyboardType

        onTextChange = item.onValueChange
        onEndEditing = item.onEndEditing

        textFieldView.textView.text = item.valueProvider()
    }
}
