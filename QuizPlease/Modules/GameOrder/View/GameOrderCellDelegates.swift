//
//  GameOrderCellDelegates.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Game Annotation
extension GameOrderVC: GameAnnotationCellDelegate {
    func gameAnnotation(for cell: GameAnnotationCell) -> String {
        presenter.game.description
    }
    
    func signUpButtonPressed(in cell: GameAnnotationCell) {
        scrollToSignUp()
    }
}

//MARK:- Game Info
extension GameOrderVC: GameInfoCellDelegate {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo {
        return presenter.game
    }
}


//MARK:- Game Description
extension GameOrderVC: GameDescriptionDelegate {
    func optionalDescription(for descriptionCell: GameGeneralDescriptionCell) -> String? {
        return presenter.game.optionalDescription
    }
}


//MARK:- Register
extension GameOrderVC: GameRegisterCellDelegate {
    func selectedNumberOfPeople(in registerCell: GameRegisterCell) -> Int {
        return presenter.registerForm.count
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeNumberOfPeopleInTeam number: Int) {
        presenter.registerForm.count = number
        guard
            let index = items.firstIndex(where: { $0 == .onlinePayment }),
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameOnlinePaymentCell
        else {
            return
        }
        cell.updateMaxNumberOfPeople(number)
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeTeamName newName: String) {
        presenter.registerForm.teamName = newName
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeCaptainName newName: String) {
        presenter.registerForm.captainName = newName
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeEmail email: String) {
        presenter.registerForm.email = email
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangePhone extractedNumber: String, didCompleteMask: Bool) {
        presenter.isPhoneNumberValid = didCompleteMask
        presenter.registerForm.phone = extractedNumber
    }
    
    func registerCell(_ registerCell: GameRegisterCell, didChangeFeedback newValue: String) {
        presenter.registerForm.comment = newValue
    }
}


//MARK:- Certificate
extension GameOrderVC: GameCertificateCellDelegate {
    func titleForCell(_ certificateCell: GameCertificateCell) -> String {
        if certificateCell.associatedItemKind == .certificate {
            certificateCell.fieldView.title = "Введите номер сертификата/промокода"
            return "У Вас есть промокод / сертификат Квиз, плиз! ?"
        }
        certificateCell.fieldView.title = "Введите промокод"
        return "У Вас есть промокод?"
    }
    
    func accessoryText(for certificateCell: GameCertificateCell) -> String {
//        if items.filter({ $0 == .certificate }).count > 1,
//           let indexOfFirstCertificate = indexOfFirstCertificate,
//           let cell = tableView.cellForRow(at: IndexPath(row: indexOfFirstCertificate, section: 0)),
//           cell != certificateCell {
//            return ""
//        }
//
        switch certificateCell.associatedItemKind {
        case .certificate:
            return "Для активации сертификатов от наших партнеров свяжитесь с нами"
        default:
            return ""
        }
    }
    
    func certificateCell(_ certificateCell: GameCertificateCell, didChangeCertificateCode newCode: String) {
        guard let index = indexForPresenter(of: certificateCell) else { return }
        presenter.didChangeSpecialCondition(newValue: newCode, at: index)
        
        let certificatesCount = items
            .filter { $0 == .certificate }
            .count
        if newCode.isEmpty,
           certificatesCount == 1,
           let index = items.firstIndex(of: .addExtraCertificate) {
            items.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else if !newCode.isEmpty,
                  items.firstIndex(of: .addExtraCertificate) == nil,
                  let i = items.lastIndex(of: .certificate) {
            let index = i + 1
            items.insert(.addExtraCertificate, at: index)
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
        
//        switch certificateCell.associatedItemKind {
//        case .certificate:
//            presenter.registerForm.certificates = newCode
//        case .promocode:
//            presenter.registerForm.promocode = newCode
//        default:
//            break
//        }
    }
    
    func didPressOkButton(in certificateCell: GameCertificateCell) {
        view.endEditing(true)
        guard let index = indexForPresenter(of: certificateCell) else { return }
        presenter.didPressCheckSpecialCondition(at: index)
//        switch certificateCell.associatedItemKind {
//        case .certificate:
//            presenter.checkCertificate()
//        case .promocode:
//            presenter.checkPromocode()
//        default:
//            break
//        }
    }
    
    func certificateCellDidEndEditing(_ certificateCell: GameCertificateCell) {
        guard let index = indexForPresenter(of: certificateCell) else { return }
        presenter.didEndEditingSpecialCondition(at: index)
    }
}

//MARK:- Add Extra Certificate
extension GameOrderVC: GameAddExtraCertificateCellDelegate {
    func cellDidPressAddButton(_ cell: GameAddExtraCertificateCell) {
        presenter.didPressAddSpecialCondition()
    }
}

//MARK:- First Play
extension GameOrderVC: GameFirstPlayCellDelegate {
    func firstPlayCell(_ cell: GameFirstPlayCell, didChangeStateTo isFirstPlay: Bool) {
        presenter.registerForm.isFirstTime = isFirstPlay
//        if isFirstPlay {
//            guard let i = items.firstIndex(of: .firstPlay) else { return }
//            let index = i + 1
//            items.insert(.promocode, at: index)
//            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//        } else {
//            guard let index = items.firstIndex(of: .promocode) else { return }
//            items.remove(at: index)
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) as? GameCertificateCell {
//                cell.fieldView.textField.text = nil
//            }
//            presenter.registerForm.promocode = nil
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
}

//MARK:- Payment Type
extension GameOrderVC: GamePaymentTypeCellDelegate {
    func availablePaymentTypes(in cell: GamePaymentTypeCell) -> [PaymentType] {
        return presenter.game.availablePaymentTypes
    }
    
    func isOnlinePaymentInitially(in cell: GamePaymentTypeCell) -> Bool {
        return presenter.isOnlinePaymentDefault
    }
    
    func paymentTypeCell(_ cell: GamePaymentTypeCell, didChangePaymentType isOnlinePayment: Bool) {
        presenter.registerForm.paymentType = isOnlinePayment ? .online : .cash
        
        if let index = items.firstIndex(of: .submit), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameSubmitButtonCell {
            let title = isOnlinePayment ? "Оплатить игру" : "Записаться на игру"
            cell.updateTitle(with: title)
        }
        
        //guard !isFirstLoad else { isFirstLoad = false; return }
        
        if isOnlinePayment {
            guard let i = items.firstIndex(of: .paymentType), i+1 < items.count,
                  items[i+1] != .onlinePayment
            else { return }
            let index = i + 1
            
            items.insert(.onlinePayment, at: index)
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            
        } else {
            presenter.registerForm.countPaidOnline = nil
            
            guard let index = items.firstIndex(of: .onlinePayment) else { return }
            items.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}

//MARK:- Online Payment
extension GameOrderVC: GameOnlinePaymentCellDelegate {
    func shouldDisplayCountPicker(in cell: GameOnlinePaymentCell) -> Bool {
        return !presenter.game.isOnlineGame
    }
    
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.countPaidOnline ?? presenter.registerForm.count
    }
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.registerForm.count
    }
    
    func sumToPay(in cell: GameOnlinePaymentCell, forNumberOfPeople number: Int) -> Double {
        return presenter.countSumToPay(forPeople: number)
    }
    
    func priceTextColor(in cell: GameOnlinePaymentCell) -> UIColor? {
        presenter.getPriceTextColor()
    }
}


//MARK:- Submit Button
extension GameOrderVC: GameSubmitButtonCellDelegate {
    func titleForButton(in cell: GameSubmitButtonCell) -> String? {
        let isOnlinePayment = presenter.registerForm.paymentType == .online
        let title = isOnlinePayment ? "Оплатить игру" : "Записаться на игру"
        return title
    }
    
    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton) {
        presenter.didPressSubmitButton()
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
