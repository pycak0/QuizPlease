//
//  GamePageAnnotationCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let sideSpacing: CGFloat = 20
    static let bottomSpacing: CGFloat = 8
}

/// GapePage cell containing annotation of the game
final class GamePageAnnotationCell: UITableViewCell {

    // MARK: - UI Elements

    private let annotationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .gilroy(.medium, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(annotationLabel)
        NSLayoutConstraint.activate([
            annotationLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideSpacing),
            annotationLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.sideSpacing),
            annotationLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideSpacing),
            annotationLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.bottomSpacing)
        ])
    }
}

// MARK: - GamePageCellProtocol

extension GamePageAnnotationCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageAnnotationItem else { return }
        annotationLabel.text = item.text
    }
}
