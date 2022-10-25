//
//  MenuProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuProfileCellDelegate: AnyObject {
    func addGameButtonPressed(in cell: MenuProfileCell)

    func userPoints(in cell: MenuProfileCell) -> Double?
}

class MenuProfileCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier = "MenuProfileCell"

    weak var delegate: MenuProfileCellDelegate?

    private let numberDecorator = BigNumberDecorator()
    private let pointsDecorator = PointsDecorator()

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var addGameButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    @IBAction func addGameButtonPressed(_ sender: Any) {
        delegate?.addGameButtonPressed(in: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2

        addGameButton.layer.cornerRadius = addGameButton.frame.height / 2
        profileLabel.layer.cornerRadius = profileLabel.frame.height / 2

        cellView.layer.cornerRadius = cellViewCornerRadius
    }

    func reloadUserPoints() {
        if let points = delegate?.userPoints(in: self) {
            setUserPoints(points)
        } else {
            hideUserPoints()
        }
    }

    func setUserPoints(_ points: Double) {
        accessoryLabel.text = {
            if points >= 100_000 {
                return numberDecorator.string(from: points as NSNumber).map { "\($0) баллов" }
            } else {
                return pointsDecorator.string(from: points as NSNumber)
            }
        }()
        accessoryLabel.isHidden = false
    }

    func hideUserPoints() {
        accessoryLabel.isHidden = true
        accessoryLabel.text = ""
    }

    func configureCell(with model: MainMenuItemProtocol) {
        titleLabel.text = model.title
        // accessoryLabel.text = model.supplementaryText
    }

    func configureViews() {
        accessoryLabel.isHidden = true
        commentLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        commentLabel.text = "Добавляйте игры, получайте баллы и тратьте их на приятности!"

        cellView.addGradient(
            colors: [.yellow, .lightOrange],
            frame: CGRect(
                origin: contentView.bounds.origin,
                size: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: contentView.bounds.height
                )
            ),
            insertAt: 0
        )
        // gradientView.addGradient(colors: [.yellow, .lightOrange], frame: contentView.bounds)
    }
}
