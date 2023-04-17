//
//  GamePagePaymentTypeCell.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizontalSpacing: CGFloat = 16
    static let topSpacing: CGFloat = 8
    static let bottomSpacing: CGFloat = 16
}

/// GamePage cell to select payment type
final class GamePagePaymentTypeCell: UITableViewCell {

    private var didChangePaymentType: ((_ newPaymentTypeName: String) -> Void)?

    private var paymentTypes: [String] = [] {
        didSet {
            paymentOptionsStackView.removeArrangedSubviews()
            paymentTypes
                .map(makeOption(title:))
                .forEach(paymentOptionsStackView.addArrangedSubview(_:))
        }
    }

    // MARK: - UI Elements

    private let paymentOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray5Adapted
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(paymentOptionsStackView)
        NSLayoutConstraint.activate([
            paymentOptionsStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            paymentOptionsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            paymentOptionsStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            paymentOptionsStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }

    private func makeOption(title: String) -> UIView {
        let checkboxView = CheckboxView()
        checkboxView.tintColor = .systemBlue
        checkboxView.canDeselect = false
        checkboxView.title = title
        checkboxView.addTarget(self, action: #selector(checkboxValueChanged(_:)), for: .valueChanged)
        return checkboxView
    }

    @objc
    private func checkboxValueChanged(_ sender: CheckboxView) {
        let checkboxes = (paymentOptionsStackView.arrangedSubviews as? [CheckboxView]) ?? []
        for checkbox in checkboxes where checkbox.title != sender.title {
            checkbox.isSelected = false
        }
        if let currentType = sender.title {
            didChangePaymentType?(currentType)
        }
    }

    private func selectPaymentType(title: String) {
        let checkboxes = (paymentOptionsStackView.arrangedSubviews as? [CheckboxView]) ?? []
        checkboxes.first(where: { $0.title == title})?.isSelected = true
    }
}

// MARK: - GamePageCellProtocol

extension GamePagePaymentTypeCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePagePaymentTypeItem else { return }
        didChangePaymentType = item.onSelectionChange
        paymentTypes = item.paymentTypeNames
        selectPaymentType(title: item.getSelectedPaymentType())
    }
}
