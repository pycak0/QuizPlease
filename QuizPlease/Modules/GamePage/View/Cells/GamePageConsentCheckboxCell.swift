//
//  GamePageConsentCheckboxCell.swift
//  QuizPlease
//
//  Created on 15.03.2026.
//

import UIKit

/// GamePage consent checkbox cell with tappable links and error state support
final class GamePageConsentCheckboxCell: UITableViewCell {

    // MARK: - UI Elements

    private let checkboxView: AgreementCheckboxView = {
        let checkbox = AgreementCheckboxView()
        checkbox.checkboxColor = .lightGreen
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    private var onValueChange: ((Bool) -> Void)?

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray6Adapted
        makeLayout()
        checkboxView.addTarget(self, action: #selector(checkboxChanged), for: .valueChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func showError() {
        checkboxView.showError()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(checkboxView)
        NSLayoutConstraint.activate([
            checkboxView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            checkboxView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            checkboxView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 16),
            checkboxView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    @objc
    private func checkboxChanged() {
        onValueChange?(checkboxView.isSelected)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageConsentCheckboxCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageConsentCheckboxItem else { return }
        checkboxView.configure(
            text: item.text,
            links: item.links
        )
        checkboxView.isSelected = item.getIsSelected()
        onValueChange = item.onValueChange
        checkboxView.onLinkTap = item.onLinkTap
    }
}
