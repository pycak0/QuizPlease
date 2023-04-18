//
//  GamePagePaymentSumCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let horizontalSpacing: CGFloat = 16
    static let topSpacing: CGFloat = 0
    static let bottomSpacing: CGFloat = 16
}

/// GamePage cell displaying the payment sum
final class GamePagePaymentSumCell: UITableViewCell {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма к оплате"
        label.font = .gilroy(.semibold, size: 16)
        label.textColor = .darkGray
        label.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        label.font = .gilroy(.semibold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dashView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override func layoutSubviews() {
        super.layoutSubviews()
        redrawDashedLine()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            titleLabel,
            dashView,
            priceLabel
        ].forEach(stackView.addArrangedSubview(_:))

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing),
            dashView.heightAnchor.constraint(equalTo: priceLabel.heightAnchor)
//            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func redrawDashedLine() {
        dashView.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        let verticalShift: CGFloat = 5
        let startPoint = CGPoint(x: dashView.bounds.minX + 3, y: dashView.frame.maxY - verticalShift)
        let endPoint = CGPoint(x: dashView.frame.maxX - 3, y: dashView.frame.maxY - verticalShift)
        dashView.layer.addSublayer(CAShapeLayer.dashedLine(start: startPoint, end: endPoint))
    }

    private func setPaymentSum(_ price: Double, priceColor: UIColor?) {
        priceLabel.text = NumberFormatter.decimalFormatter.string(from: price as NSNumber) ?? "N/A"
        priceLabel.textColor = priceColor ?? .labelAdapted
    }
}

// MARK: - GamePageCellProtocol

extension GamePagePaymentSumCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePagePaymentSumItem else { return }
        let price = item.getPaymentSum()
        let priceColor = item.getPriceTextColor()
        setPaymentSum(price, priceColor: priceColor)
    }
}

extension CAShapeLayer {

    /// Creates a dashed-line layer with given parameters
    static func dashedLine(
        start: CGPoint,
        end: CGPoint,
        width: CGFloat = 1,
        dashLength: Double = 4,
        gapLength: Double = 3
    ) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [dashLength, gapLength] as [NSNumber] // [length of dash, length of gap]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path

        return shapeLayer
    }
}
