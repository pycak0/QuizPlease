//
//  GamePageAddSpecialConditionCell.swift
//  QuizPlease
//
//  Created by Владислав on 15.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage cell with "add" button for special conditions
final class GamePageAddSpecialConditionCell: UITableViewCell {

    var tapAction: (() -> Void)?

    // MARK: - UI Elements

    private lazy var addButton: UIButton = {
        let button = ScalingButton()
        button.backgroundColor = .lightGreen
        button.tintColor = .systemBackgroundAdapted
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.setTitle("Ещё сертификат или промокод", for: .normal)
        button.titleLabel?.font = .gilroy(.bold, size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightGreen.withAlphaComponent(0.2)
        selectionStyle = .none
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    @objc
    private func addButtonPressed() {
        tapAction?()
    }
}

// MARK: - GamePageCellProtocol

extension GamePageAddSpecialConditionCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        // TODO
    }
}
