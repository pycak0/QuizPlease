//
//  DebugSettingsSwitchCell.swift
//  QuizPlease
//
//  Created by Владислав on 21.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

final class DebugSettingsSwitchCell: UITableViewCell {

    private var onToggleChange: ((Bool) -> Void)?

    // MARK: - UI Elements

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        return toggle
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.numberOfLines = 0
        accessoryView = toggle
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: DebugSettingsSwitchItem) {
        textLabel?.text = item.title
        toggle.isOn = item.isEnabledProvider()
        onToggleChange = item.onValueChange
    }

    // MARK: - Private Methods

    @objc
    private func toggleChanged() {
        onToggleChange?(toggle.isOn)
    }
}
