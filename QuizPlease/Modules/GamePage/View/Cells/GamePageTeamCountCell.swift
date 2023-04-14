//
//  GamePageTeamCountCell.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let topSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 6
    static let pickerHeight: CGFloat = 75
}

/// GamePage cell with team count picker
final class GamePageTeamCountCell: UITableViewCell {

    private var onCountChange: ((Int) -> Void)?

    // MARK: - UI Elements

    private lazy var countPickerView: CountPickerView = {
        let countPickerView = CountPickerView()
        countPickerView.buttonsCornerRadius = 15
        countPickerView.title = "Количество человек в команде"
        countPickerView.pickerBackgroundColor = .systemGray5Adapted
        countPickerView.tintColor = .labelAdapted
        countPickerView.delegate = self
        let font: UIFont = .gilroy(.semibold, size: 16)
        countPickerView.titleLabel.font = font
        countPickerView.buttonsTitleFont = font
        countPickerView.translatesAutoresizingMaskIntoConstraints = false
        return countPickerView
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

    override func prepareForReuse() {
        super.prepareForReuse()
        onCountChange = nil
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(countPickerView)
        NSLayoutConstraint.activate([
            countPickerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            countPickerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            countPickerView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            countPickerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing),
            countPickerView.heightAnchor.constraint(equalToConstant: Constants.pickerHeight)
        ])
    }
}

// MARK: - CountPickerViewDelegate

extension GamePageTeamCountCell: CountPickerViewDelegate {

    func countPicker(_ picker: CountPickerView, didChangeSelectedNumber number: Int) {
        onCountChange?(number)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageTeamCountCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageTeamCountItem else { return }
        onCountChange = item.changeHandler
        let index = item.getSelectedTeamCount() - countPickerView.startCount
        countPickerView.setSelectedButton(at: index, animated: true)
    }
}
