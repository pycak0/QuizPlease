//
//  GamePagePollCell.swift
//  QuizPlease
//
//  Created by Владислав on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
    static let titleSpacing: CGFloat = 16
    static let itemSpacing: CGFloat = 10
}

/// GamePage view cell that shows multiple options to select from
final class GamePagePollCell: UITableViewCell {

    // MARK: - Private Properties

    private var canDeselect = false

    private var didChangeSelectedValue: ((_ newPaymentTypeName: String) -> Void)?

    private var values: [String] = [] {
        didSet {
            pollStackView.removeArrangedSubviews()
            values
                .map(makeOption(title:))
                .forEach(pollStackView.addArrangedSubview(_:))
        }
    }

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.itemSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

    override func becomeFirstResponder() -> Bool {
        titleLabel.shake()
        return super.becomeFirstResponder()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(pollStackView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),

            pollStackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: Constants.titleSpacing),
            pollStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            pollStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            pollStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    private func makeOption(title: String) -> UIView {
        let checkboxView = CheckboxView()
        checkboxView.tintColor = .lemon
        checkboxView.canDeselect = canDeselect
        checkboxView.title = title
        checkboxView.addTarget(self, action: #selector(checkboxValueChanged(_:)), for: .valueChanged)
        return checkboxView
    }

    @objc
    private func checkboxValueChanged(_ sender: CheckboxView) {
        let checkboxes = (pollStackView.arrangedSubviews as? [CheckboxView]) ?? []
        for checkbox in checkboxes where checkbox.title != sender.title {
            checkbox.isSelected = false
        }
        if let value = sender.title {
            didChangeSelectedValue?(value)
        }
    }

    private func select(value: String) {
        let checkboxes = (pollStackView.arrangedSubviews as? [CheckboxView]) ?? []
        checkboxes.first(where: { $0.title == value})?.isSelected = true
    }
}

// MARK: - GamePageCellProtocol

extension GamePagePollCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePagePollItem else { return }
        canDeselect = !item.isRequired
        titleLabel.text = item.title
        values = item.values
        didChangeSelectedValue = item.onSelectionChange
        if let value = item.getSelectedValue() {
            select(value: value)
        }
    }
}
