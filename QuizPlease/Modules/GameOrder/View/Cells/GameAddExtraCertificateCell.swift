//
//  GameAddExtraCertificateCell.swift
//  QuizPlease
//
//  Created by Владислав on 05.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

protocol GameAddExtraCertificateCellDelegate: AnyObject {
    func cellDidPressAddButton(_ cell: GameAddExtraCertificateCell)
}

class GameAddExtraCertificateCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "\(GameAddExtraCertificateCell.self)"
    
    private weak var _delegate: GameAddExtraCertificateCellDelegate?
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameAddExtraCertificateCellDelegate }
    }

    private lazy var addButton: UIButton = {
        let button = ScalingButton()
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 20
        button.setTitle("Ещё сертификат или промокод", for: .normal)
        button.titleLabel?.font = .gilroy(.bold, size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        button.tintColor = .systemBackgroundAdapted
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(addButton)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    @objc private func addButtonPressed() {
        _delegate?.cellDidPressAddButton(self)
    }
}
