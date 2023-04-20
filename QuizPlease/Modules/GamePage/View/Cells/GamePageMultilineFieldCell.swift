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
        titledTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset)
    }()

    private lazy var bottomConstraint: NSLayoutConstraint = {
        titledTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomInset)
    }()

    // MARK: - UI Elements

    private lazy var titledTextView: TitledTextView = {
        let textFieldView = TitledTextView()
        textFieldView.delegate = self
        textFieldView.linesLimit = 5
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
        return titledTextView.becomeFirstResponder()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(titledTextView)
        NSLayoutConstraint.activate([
            titledTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            titledTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            topConstraint,
            bottomConstraint
        ])
    }
}

// MARK: - TitledTextViewDelegate

extension GamePageMultilineFieldCell: TitledTextViewDelegate {

    func textView(_ textView: TitledTextView, didChangeText text: String) {
        onTextChange?(text)
        invalidateIntrinsicContentSize()
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

        titledTextView.title = item.title
        titledTextView.placeholder = item.placeholder

        titledTextView.backgroundColor = item.fieldColor
        contentView.backgroundColor = item.backgroundColor
//        titledTextView.textView.textContentType = item.options.contentType
        titledTextView.autocapitalizationType = item.options.capitalizationType
        titledTextView.keyboardType = item.options.keyboardType

        onTextChange = item.onValueChange
        onEndEditing = item.onEndEditing

        titledTextView.text = item.valueProvider() ?? ""
        invalidateIntrinsicContentSize()
    }
}
