//
//  GamePageCheckboxCell.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let verticalSpacing: CGFloat = 25
    static let horizontalSpacing: CGFloat = 16
}

/// GamePage Checkbox cell
final class GamePageCheckboxCell: UITableViewCell {

    private var tapAction: ((Bool) -> Void)?

    // MARK: - UI Elements

    private let checkboxView: CheckboxView = {
        let checkboxView = CheckboxView()
        checkboxView.tintColor = .lemon
        checkboxView.translatesAutoresizingMaskIntoConstraints = false
        return checkboxView
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        makeLayout()
        checkboxView.addTarget(self, action: #selector(checkboxPressed), for: .valueChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(checkboxView)
        NSLayoutConstraint.activate([
            checkboxView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            checkboxView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            checkboxView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            checkboxView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing)
        ])
    }

    @objc
    private func checkboxPressed() {
        tapAction?(checkboxView.isSelected)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageCheckboxCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageCheckboxItem else { return }
        checkboxView.title = item.title
        checkboxView.isSelected = item.getIsSelected()
        tapAction = item.onValueChange
    }
}
