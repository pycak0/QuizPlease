//
//  GamePageAgreementCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 4
    static let horizontalSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 20
    static let agreementFontSize: CGFloat = 12
}

/// GamePage agreement cell
final class GamePageAgreementCell: UITableViewCell {

    private var detectLinks: ((NSRange) -> Void)?

    // MARK: - UI Elements

    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
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
        addTapRecognizerToTextView()
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            textView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            textView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            textView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    private func addTapRecognizerToTextView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextTap(_:)))
        textView.addGestureRecognizer(tapRecognizer)
    }

    private func configureLinkTextView(text: String, links: [TextLink]) {
        let nsString = text as NSString
        let wholeRange = nsString.range(of: text)
        let attrString = NSMutableAttributedString(string: text)
        let font: UIFont = .gilroy(.semibold, size: Constants.agreementFontSize)
        attrString.addAttributes([
                .font: font,
                .foregroundColor: UIColor.opaqueSeparatorAdapted
            ],
            range: wholeRange
        )

        for link in links {
            let rangeOfLink = nsString.range(of: link.text)
            attrString.addAttributes([.foregroundColor: UIColor.themePink], range: rangeOfLink)
        }

        textView.attributedText = attrString
        textView.textAlignment = .center

        detectLinks = { rangeOfTap in
            for link in links {
                let rangeOfLink = nsString.range(of: link.text)
                if rangeOfTap.intersection(rangeOfLink) != nil {
                    link.action()
                    break
                }
            }
        }
    }

    // MARK: - Handle Tap on Text

    @objc private func handleTextTap(_ sender: UITapGestureRecognizer) {
        guard let textView = sender.view as? UITextView else { return }
        let layoutManager = textView.layoutManager

        // location of tap in textView coordinates and taking the inset into account
        var location = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top

        // character index at tap location
        let characterIndex = layoutManager.characterIndex(
            for: location,
            in: textView.textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        guard characterIndex > 0, characterIndex < textView.textStorage.length else { return }

        let rangeOfTap = NSRange(location: characterIndex, length: 1)
        detectLinks?(rangeOfTap)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageAgreementCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageAgreementItem else { return }
        configureLinkTextView(text: item.text, links: item.links)
    }
}
