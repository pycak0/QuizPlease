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
    static let bottomSpacing: CGFloat = 20
    static let pickerHeight: CGFloat = 75
}

/// GamePage cell with team count picker
final class GamePageTeamCountCell: UITableViewCell {

    private var onCountChange: ((Int) -> Void)?

    // MARK: - UI Elements

    private lazy var countPickerView: CountPickerView = {
        let countPickerView = CountPickerView()
        countPickerView.buttonsCornerRadius = 15
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
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing)
//            countPickerView.heightAnchor.constraint(equalToConstant: Constants.pickerHeight)
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
        backgroundColor = item.backgroundColor
        countPickerView.pickerBackgroundColor = item.pickerColor
        onCountChange = item.changeHandler
        countPickerView.title = item.title ?? ""
        let minCount = item.getMinCount()
        let maxCount = item.getMaxCount()
        let selectedCount = item.getSelectedTeamCount()
        countPickerView.startCount = minCount
        countPickerView.maxButtonsCount = maxCount - minCount + 1

        let actualSelectedCount = min(max(minCount, selectedCount), maxCount)
        let index = actualSelectedCount - minCount
        countPickerView.setSelectedButton(at: index, animated: false)
        if actualSelectedCount != selectedCount {
            onCountChange?(actualSelectedCount)
        }
    }
}
