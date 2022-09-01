//
//  ScheduleGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 11.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
protocol ScheduleGameCellDelegate: AnyObject {
    func signUpButtonPressed(in cell: ScheduleGameCell)
    func infoButtonPressed(in cell: ScheduleGameCell)
    func locationButtonPressed(in cell: ScheduleGameCell)
    func remindButtonPressed(in cell: ScheduleGameCell)
    func gameNamePressed(in cell: ScheduleGameCell)
    func gameNumberPressed(in cell: ScheduleGameCell)
}

class ScheduleGameCell: UITableViewCell {
    static let identifier = "\(ScheduleGameCell.self)"

    weak var delegate: ScheduleGameCellDelegate?

    // MARK: - Outlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!

    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.addTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self.delegate?.gameNamePressed(in: self)
            }
        }
    }

    @IBOutlet private weak var numberLabel: UILabel! {
        didSet {
            numberLabel.addTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self.delegate?.gameNumberPressed(in: self)
            }
        }
    }

    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var remindButton: UIButton!
    @IBOutlet private weak var infoButton: UIButton!

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gameStatusLabel: UILabel!
    @IBOutlet private weak var statusImageView: UIImageView!

    @IBOutlet private weak var signUpButton: UIButton!

    // MARK: - Actions
    @IBAction private func signUpButtonPressed(_ sender: Any) {
        delegate?.signUpButtonPressed(in: self)
    }

    @IBAction private func infoButtonPressed(_ sender: Any) {
        delegate?.infoButtonPressed(in: self)
    }

    @IBAction private func locationButtonPressed(_ sender: Any) {
        delegate?.locationButtonPressed(in: self)
    }

    @IBAction private func remindButtonPressed(_ sender: Any) {
        delegate?.remindButtonPressed(in: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onReuseActions()
    }

    // MARK: - Configure Cell Data

    func fill(viewModel: ScheduleGameCellViewModel) {
        let gameInfo = viewModel.gameInfo
        nameLabel.text = gameInfo.nameGame
        numberLabel.text = gameInfo.gameNumber
        placeNameLabel.text = gameInfo.placeInfo.title
        placeAddressLabel.text = gameInfo.placeInfo.shortAddress
        timeLabel.text = "в \(gameInfo.time)"
        priceLabel.text = gameInfo.priceDetails
        dateLabel.text = gameInfo.formattedDate

        gameStatusLabel.text = gameInfo.gameStatus?.comment ?? ""
        signUpButton.setTitle(gameInfo.gameStatus?.buttonTitle ?? "Запись недоступна", for: .normal)

        let cellAccentColor = gameInfo.gameStatus?.accentColor ?? .themeGray
        cellView.layer.borderColor = cellAccentColor.cgColor
        signUpButton.backgroundColor = cellAccentColor

        statusImageView.image = gameInfo.gameStatus?.image

        switch gameInfo.gameStatus {
        case .placesAvailable, .reserveAvailable, .fewPlaces:
            setButtons(enabled: true)
        default:
            setButtons(enabled: false)
        }

        let subscribeButton = viewModel.subscribeButtonViewModel

        remindButton.isHidden = !subscribeButton.isPresented
        remindButton.tintColor = subscribeButton.tintColor
        remindButton.setTitleColor(subscribeButton.tintColor, for: .normal)
        remindButton.backgroundColor = subscribeButton.backgroundColor
        remindButton.setTitle(subscribeButton.title, for: .normal)

        if let path = gameInfo.imageData?.pathProof {
            backgroundImageView.loadImage(path: path)
        }
    }

    private func onReuseActions() {
        delegate = nil
        backgroundImageView.image = nil
        setButtons(enabled: true)
    }

    private func setButtons(enabled: Bool) {
        signUpButton.isEnabled = enabled
        infoButton.isEnabled = enabled
    }

    private func configureViews() {
        cellView.layer.cornerRadius = 20
        // cellView.layer.borderColor = UIColor.lightGreen.cgColor
        cellView.layer.borderWidth = 4

        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        locationButton.layer.cornerRadius = locationButton.frame.height / 2
        remindButton.layer.cornerRadius = remindButton.frame.height / 2
    }

    private func animateDataFilling() {
        alpha = 0
        UIView.animate(withDuration: CATransaction.animationDuration()) {
            self.alpha = 1
        }
    }

}
