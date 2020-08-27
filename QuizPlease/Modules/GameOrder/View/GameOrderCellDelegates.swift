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
            presenter.registerForm.countPaidOnline = nil
            
            guard items.count == GameInfoItemKind.allCases.count else { return }
            items.remove(at: onlinePaymentKind.rawValue)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if let index = items.firstIndex(of: .submit), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameSubmitButtonCell {
            cell.submitButton.setTitle(isOnlinePayment ? "Оплатить игру" : "Записаться на игру", for: .normal)
        }
    }
}

extension GameOrderVC: GameOnlinePaymentCellDelegate {
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.countPaidOnline ?? presenter.registerForm.count
    }
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.count
    }
    
    func sumToPay(in cell: GameOnlinePaymentCell, forNumberOfPeople number: Int) -> Int {
        presenter.registerForm.countPaidOnline = number
        return presenter.game.price * number
    }
    
}

extension GameOrderVC: GameSubmitButtonCellDelegate {
    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton) {
//        return
//
//        button.isUserInteractionEnabled = false
//        button.setTitle("Хорошо", for: .normal)
//
//        for kind in items {
//            if kind != .info, let index = items.firstIndex(of: kind) {
//                items.remove(at: index)
//                let indexPath = IndexPath(row: index, section: 0)
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.endUpdates()
//            }
//        }
//        gameImageView.isHidden = true
//        imageDarkeningView.isHidden = true
//
//        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GameInfoCell else { return }
//        cell.cellView.layer.borderColor = UIColor.systemGreen.cgColor
//        cell.cellView.layer.borderWidth = 4
    }
}
