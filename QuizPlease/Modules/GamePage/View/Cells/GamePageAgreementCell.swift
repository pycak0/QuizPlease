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
}

/// GamePage agreement cell
final class GamePageAgreementCell: UITableViewCell {

    private var tapAction: (() -> Void)?

    // MARK: - UI Elements

    private let agreementButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        let color = UIColor.opaqueSeparatorAdapted
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray6Adapted
        setupAgreementButton()
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(agreementButton)
        NSLayoutConstraint.activate([
            agreementButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            agreementButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            agreementButton.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            agreementButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    @objc
    private func highlighted() {
        agreementButton.alpha = 0.5
    }

    @objc
    private func released() {
        agreementButton.alpha = 1
    }

    private func setupAgreementButton() {
        let text = "Записываясь на игру, вы соглашаетесь c условиями пользовательского соглашения"
        let attrText = NSMutableAttributedString(string: text)
        let agreementRange = (attrText.string as NSString).range(of: "пользовательского соглашения")
        let wholeRange = (attrText.string as NSString).range(of: attrText.string)

        let pStyle = NSMutableParagraphStyle()
        pStyle.alignment = .center
        attrText.addAttributes(
            [.paragraphStyle: pStyle,
             .font: UIFont.gilroy(.semibold, size: 12)],
            range: wholeRange
        )

        attrText.addAttribute(
            .foregroundColor,
            value: UIColor.themePink,
            range: agreementRange
        )

        agreementButton.setAttributedTitle(attrText, for: .normal)
        agreementButton.addTarget(self, action: #selector(agreementButtonPressed), for: .touchUpInside)

        let highlightControlEvents: UIControl.Event = [
            .touchDown,
            .touchDragEnter,
            .touchDragInside
        ]
        agreementButton.addTarget(self, action: #selector(highlighted), for: highlightControlEvents)

        let releaseControlEvents: UIControl.Event = [
            .touchCancel,
            .touchDragExit,
            .touchUpOutside,
            .touchDragOutside,
            .touchUpInside
        ]
        agreementButton.addTarget(self, action: #selector(released), for: releaseControlEvents)
    }

    @objc
    private func agreementButtonPressed() {
        tapAction?()
    }
}

// MARK: - GamePageCellProtocol

extension GamePageAgreementCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageAgreementItem else { return }
        tapAction = item.tapAction
    }
}
