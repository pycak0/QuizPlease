//
//  GameOrderCellDelegates.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension GameOrderVC: GameAnnotationCellDelegate {
    func gameAnnotation(for cell: GameAnnotationCell) -> String {
        presenter.game.annotation
    }
    
    func signUpButtonPressed(in cell: GameAnnotationCell) {
        scrollToSignUp()
    }
    
}

extension GameOrderVC: GameInfoCellDelegate {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo {
        return presenter.game
    }
}


extension GameOrderVC: GameDescriptionDelegate {}

extension GameOrderVC: GameRegisterCellDelegate {
    func registerCell(_ registerCell: GameRegisterCell, didChangeNumberOfPeopleInTeam number: Int) {
        presenter.registerForm.count = number
        if let cell = tableView.cellForRow(at: IndexPath(row: GameInfoItemKind.onlinePayment.rawValue, section: 0)) as? GameOnlinePaymentCell {
            cell.maxNumber = number
        }
        
    }
}

extension GameOrderVC: GamePaymentTypeCellDelegate {
    func isOnlinePaymentInitially(in cell: GamePaymentTypeCell) -> Bool {
        presenter.registerForm.payment_type == .online
    }
    
    func paymentTypeCell(_ cell: GamePaymentTypeCell, didChangePaymentType isOnlinePayment: Bool) {
        presenter.registerForm.payment_type = isOnlinePayment ? .online : .cash
        let indexPath = IndexPath(row: GameInfoItemKind.onlinePayment.rawValue, section: 0)
        
        let onlinePaymentKind = GameInfoItemKind.onlinePayment
        if isOnlinePayment {
            guard items.count < GameInfoItemKind.allCases.count else { return }
            items.insert(onlinePaymentKind, at: onlinePaymentKind.rawValue)
            tableView.insertRows(at: [indexPath], with: .fade)
        } else {
            guard items.count == GameInfoItemKind.allCases.count else { return }
            items.remove(at: onlinePaymentKind.rawValue)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension GameOrderVC: GameOnlinePaymentCellDelegate {
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.count
    }
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.count
    }
    
    func sumToPay(in cell: GameOnlinePaymentCell, forNumberOfPeople number: Int) -> Int {
        return presenter.game.price * number
    }
    
}
