//
//  ScheduleGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 11.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol ScheduleGameCellDelegate: class {
    func signUpButtonPressed(in cell: ScheduleGameCell)
    func infoButtonPressed(in cell: ScheduleGameCell)
    func locationButtonPressed(in cell: ScheduleGameCell)
    func remindButtonPressed(in cell: ScheduleGameCell)
}

class ScheduleGameCell: UITableViewCell {
    static let identifier = "ScheduleGameCell"
    
    weak var delegate: ScheduleGameCellDelegate?

    //MARK:- Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var remindButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK:- Actions
    @IBAction func signUpButtonPressed(_ sender: Any) {
        delegate?.signUpButtonPressed(in: self)
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        delegate?.infoButtonPressed(in: self)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        delegate?.locationButtonPressed(in: self)
    }
    
    @IBAction func remindButtonPressed(_ sender: Any) {
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
    
    //MARK:- Configure Cell Data
    func configureCell(model: GameInfo, isSubscribed: Bool) {
        setButtons(enabled: true)
        nameLabel.text = model.nameGame
        numberLabel.text = model.gameNumber
        placeNameLabel.text = model.placeInfo.title
        placeAddressLabel.text = model.placeInfo.shortAddress
        timeLabel.text = "в \(model.time)"
        priceLabel.text = model.priceDetails
        dateLabel.text = model.formattedDate
        
        gameStatusLabel.text = model.gameStatus?.comment ?? ""
        signUpButton.setTitle(model.gameStatus?.buttonTitle ?? "Запись недоступна", for: .normal)
        switch model.gameStatus {
        case .placesAvailable:
            statusImageView.image = UIImage(named: "tick")
            let availableColor = UIColor.lightGreen
            cellView.layer.borderColor = availableColor.cgColor
            signUpButton.backgroundColor = availableColor
            
        case .reserveAvailable, .noPlaces:
            statusImageView.image = UIImage(named: "soldOut")
            let soldOutColor = UIColor.lemon
            cellView.layer.borderColor = soldOutColor.cgColor
            signUpButton.backgroundColor = soldOutColor
            
        default:
            statusImageView.image = nil
            cellView.layer.borderColor = UIColor.lightGray.cgColor
            setButtons(enabled: false)
        }
        
        let accentColor: UIColor = isSubscribed ? .black : .white
        remindButton.tintColor = accentColor
        remindButton.setTitleColor(accentColor, for: .normal)
        remindButton.backgroundColor = isSubscribed ? .lemon : .themePurple
        remindButton.setTitle(isSubscribed ? "Напомним" : "Напомнить", for: .normal)
 
        if let path = model.imageData?.pathProof {
            backgroundImageView.loadImage(path: path)
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
    
}
