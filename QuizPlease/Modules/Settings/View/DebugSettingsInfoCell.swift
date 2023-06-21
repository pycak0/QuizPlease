//
//  DebugSettingsInfoCell.swift
//  QuizPlease
//
//  Created by Владислав on 21.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

@available(iOS 13, *)
final class DebugSettingsInfoCell: UITableViewCell {

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        textLabel?.numberOfLines = 0
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: DebugSettingsInfoItem) {
        textLabel?.text = item.title
    }
}
