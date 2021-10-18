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
}

class ScheduleGameCell: UITableViewCell {
    static let identifier = "\(ScheduleGameCell.self)"
    
    weak var delegate: ScheduleGameCellDelegate?

    // MARK: - Outlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
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
    func fill(model: GameInfo, isSubscribed: Bool) {
        nameLabel.text = model.nameGame
        numberLabel.text = model.gameNumber
        placeNameLabel.text = model.placeInfo.title
        placeAddressLabel.text = model.placeInfo.shortAddress
        timeLabel.text = "в \(model.time)"
        priceLabel.text = model.priceDetails
        dateLabel.text = model.formattedDate
        
        gameStatusLabel.text = model.gameStatus?.comment ?? ""
        signUpButton.setTitle(model.gameStatus?.buttonTitle ?? "Запись недоступна", for: .normal)
        
        let cellAccentColor = model.gameStatus?.accentColor ?? .themeGray
        cellView.layer.borderColor = cellAccentColor.cgColor
        signUpButton.backgroundColor = cellAccentColor
        
        statusImageView.image = model.gameStatus?.image
        
        switch model.gameStatus {
        case .placesAvailable, .reserveAvailable, .fewPlaces:
            setButtons(enabled: true)
        default:
            setButtons(enabled: false)
        }
        
        let remindTintColor: UIColor = isSubscribed ? .black : .white
        remindButton.tintColor = remindTintColor
        remindButton.setTitleColor(remindTintColor, for: .normal)
        remindButton.backgroundColor = isSubscribed ? .lemon : .themePurple
        remindButton.setTitle(isSubscribed ? "Напомним" : "Напомнить", for: .normal)
 
        if let path = model.imageData?.pathProof {
            backgroundImageView.loadImage(path: path)
        }
        
        if model.gameStatus != nil {
        //    animateDataFilling()
        }
        
        //setNeedsLayout()
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
        //cellView.layer.borderColor = UIColor.lightGreen.cgColor
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
