//
//  GamePayCell.swift
//  QuizPlease
//
//  Created by Владислав on 22.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GamePayCellDelegate: class {
    func sumToPay(in gamePayCell: GamePayCell) -> Int
    
    ///Is not called at the initial configuration
    func gamePayCell(_ gamePayCell: GamePayCell, didChangeNumberOfPeopleToPay number: Int)
}

class GamePayCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GamePayCell"
    
    weak var delegate: GamePayCellDelegate?
    
    @IBOutlet weak var paymentTypeStack: UIStackView!
    @IBOutlet weak var cashTypeView: UIStackView!
    @IBOutlet weak var cashCheckBox: UIImageView!
    @IBOutlet weak var creditCardTypeView: UIStackView!
    @IBOutlet weak var creditCardCheckBox: UIImageView!
    @IBOutlet weak var teamCountStack: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dashView: UIView!
    @IBOutlet weak var signUpButton: ScalingButton!
    
    var isApplePay: Bool! {
        didSet {
            cashCheckBox.image = !isApplePay ? UIImage(named: "rectDot") : nil
            creditCardCheckBox.image = isApplePay ? UIImage(named: "rectDot") : nil
            let title = isApplePay ? "Оплатить игру" : "Записаться на игру"
            signUpButton.setTitle(title, for: .normal)
        }
    }
    
    var selectedNumberOfPeople: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    //MARK:- Configure Cell
    private func configureCell() {
        teamCountStack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
        
        cashTypeView.addTapGestureRecognizer {
            self.isApplePay = false
        }
        
        creditCardTypeView.addTapGestureRecognizer {
            self.isApplePay = true
        }

        let start = CGPoint(x: dashView.bounds.minX + 3, y: dashView.frame.maxY - 8)
        let end = CGPoint(x: priceLabel.frame.minX - 3, y: dashView.frame.maxY - 8)
        UIView.drawDottedLine(in: dashView, start: start, end: end, dashLength: 4, gapLength: 2)
        
        isApplePay = true
        updateUI(withNumberOfPeople: selectedNumberOfPeople)
    }
    
    @IBAction func countButtonPressed(_ sender: UIButton) {
        guard let index = teamCountStack.arrangedSubviews.firstIndex(of: sender),
            index + 1 != selectedNumberOfPeople else {
            return
        }
        
        selectedNumberOfPeople = index + 1
        delegate?.gamePayCell(self, didChangeNumberOfPeopleToPay: selectedNumberOfPeople)
        updateUI(withNumberOfPeople: selectedNumberOfPeople)
    }
    
    private func updateUI(withNumberOfPeople number: Int) {
        guard number >= 1 && number <= teamCountStack.arrangedSubviews.count else {
            return
        }
        
        teamCountStack.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            deselect(button)
        }

        let selectedButton = teamCountStack.arrangedSubviews[number - 1] as! UIButton
        select(selectedButton, number: number)
        
        let newPrice = delegate?.sumToPay(in: self) ?? 900
        priceLabel.text = "\(newPrice)"
    }
    
    //MARK:- Select
    private func select(_ button: UIButton, number: Int) {
        let scale: CGFloat = 1.1
        UIView.animate(withDuration: 0.2) {
            button.setTitle("\(number)", for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = .systemBlue
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
    }
    
    //MARK:- Deselect
    private func deselect(_ button: UIButton?) {
        var backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        }
        UIView.animate(withDuration: 0.2) {
            button?.setImage(UIImage(named: "human"), for: .normal)
            button?.setTitle("", for: .normal)
            button?.backgroundColor = backgroundColor
            button?.transform = .identity
        }
        
    }
    
}
