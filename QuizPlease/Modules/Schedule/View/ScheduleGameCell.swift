//
//  ScheduleGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 11.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ScheduleGameCellDelegate: class {
    func signUpButtonPressed(in cell: ScheduleGameCell)
    func infoButtonPressed(in cell: ScheduleGameCell)
    func locationButtonPressed(in cell: ScheduleGameCell)
    func remindButtonPressed(in cell: ScheduleGameCell)
}

class ScheduleGameCell: UITableViewCell {
    static let identifier = "ScheduleGameCell"
    
    weak var delegate: ScheduleGameCellDelegate?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var remindButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    func configureCell(model: GameInfo) {
        nameLabel.text = model.nameGame
        numberLabel.text = model.numberGame
        placeNameLabel.text = model.placeInfo.title
        placeAddressLabel.text = model.placeInfo.address
        timeLabel.text = "в \(model.time)"
        priceLabel.text = model.priceDetails
        
        setNeedsLayout()
    }
    
    private func configureViews() {
        cellView.layer.cornerRadius = 20
        cellView.layer.borderColor = UIColor.lightGreen.cgColor
        cellView.layer.borderWidth = 4
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        locationButton.layer.cornerRadius = locationButton.frame.height / 2
        remindButton.layer.cornerRadius = remindButton.frame.height / 2
    }
    
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
    
}
