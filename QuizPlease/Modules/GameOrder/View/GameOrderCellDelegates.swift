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
        presenter.game.description
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


//MARK:- Register
extension GameOrderVC: GameRegisterCellDelegate {
    func selectedNumberOfPeople(in registerCell: GameRegisterCell) -> Int {
        return presenter.registerForm.count
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeNumberOfPeopleInTeam number: Int) {
        presenter.registerForm.count = number
        if let cell = tableView.cellForRow(at: IndexPath(row: GameInfoItemKind.onlinePayment.rawValue, section: 0)) as? GameOnlinePaymentCell {
            cell.updateMaxNumberOfPeople(number)
        }
        
    }
}

//MARK:- Payment Type
extension GameOrderVC: GamePaymentTypeCellDelegate {
    func availablePaymentTypes(in cell: GamePaymentTypeCell) -> [PaymentType] {
        return presenter.game.availablePaymentTypes
    }
    
    func isOnlinePaymentInitially(in cell: GamePaymentTypeCell) -> Bool {
        presenter.registerForm.payment_type == .online
    }
    
    func paymentTypeCell(_ cell: GamePaymentTypeCell, didChangePaymentType isOnlinePayment: Bool) {
        presenter.registerForm.payment_type = isOnlinePayment ? .online : .cash
        let indexPath = IndexPath(row: GameInfoItemKind.onlinePayment.rawValue, section: 0)
        
        let onlinePaymentSection = GameInfoItemKind.onlinePayment
        if let index = items.firstIndex(of: .submit), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameSubmitButtonCell {
            let title = isOnlinePayment ? "Оплатить игру" : "Записаться на игру"
            cell.updateTitle(with: title)
        }
        
        //guard !isFirstLoad else { isFirstLoad = false; return }
        
        if isOnlinePayment {
            guard items.count < GameInfoItemKind.allCases.count else { return }
            items.insert(onlinePaymentSection, at: onlinePaymentSection.rawValue)
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            //tableView.insertRows(at: [indexPath], with: .fade)
        } else {
            presenter.registerForm.countPaidOnline = nil
            
            guard items.count == GameInfoItemKind.allCases.count else { return }
            items.remove(at: onlinePaymentSection.rawValue)
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

//MARK:- Online Payment
extension GameOrderVC: GameOnlinePaymentCellDelegate {
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.countPaidOnline ?? presenter.registerForm.count
    }
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.count
    }
    
    func sumToPay(in cell: GameOnlinePaymentCell, forNumberOfPeople number: Int) -> Int {
        presenter.registerForm.countPaidOnline = number
        return (presenter.game.priceNumber ?? 0) * number
    }
    
}


//MARK:- Submit Button
extension GameOrderVC: GameSubmitButtonCellDelegate {
    func titleForButton(in cell: GameSubmitButtonCell) -> String? {
        let isOnlinePayment = presenter.registerForm.payment_type == .online
        let title = isOnlinePayment ? "Оплатить игру" : "Записаться на игру"
        return title
    }
    
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
