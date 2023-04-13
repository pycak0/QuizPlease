//
//  GamePageDescriptionCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizaontalSpacing: CGFloat = 16
    static let verticalSpacing: CGFloat = 16
}

/// GamePage cell with game description
final class GamePageDescriptionCell: UITableViewCell {

    // MARK: - UI Elements

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .gilroy(.medium, size: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray6Adapted
        setContentCompressionResistancePriority(.init(1000), for: .vertical)
        setContentHuggingPriority(.init(252), for: .vertical)
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizaontalSpacing),
            descriptionTextView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizaontalSpacing),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing)
        ])
    }

    private func setDescription(_ text: String) {
        DispatchQueue.global().async { [weak self] in
            guard let attrString = text.htmlFormatted()?.trimmingWhitespacesAndNewlines() else {
                return
            }

            let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
            let range = (mutableAttrString.string as NSString).range(of: mutableAttrString.string)
            mutableAttrString.addAttributes([
                .font: UIFont.gilroy(.medium, size: 14),
                .foregroundColor: UIColor.labelAdapted
            ], range: range)

            DispatchQueue.main.async {
                guard let self else { return }
                self.descriptionTextView.attributedText = mutableAttrString
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension GamePageDescriptionCell: UITextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldInteractWith url: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
//        UIApplication.shared.open(url)
        return true
    }
}

// MARK: - GamePageCellProtocol

extension GamePageDescriptionCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageDescriptionItem else { return }
        descriptionTextView.text = item.description.removingAngleBrackets(replaceWith: " ")
        setDescription(item.description)
    }
}
