//
//  GameOrderCellDelegates.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Game Annotation

extension GameOrderVC: GameAnnotationCellDelegate {
    func gameAnnotation(for cell: GameAnnotationCell) -> String {
        presenter.game.description
    }

    func signUpButtonPressed(in cell: GameAnnotationCell) {
        scrollToSignUp()
    }
}

// MARK: - Game Info

extension GameOrderVC: GameInfoCellDelegate {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo {
        return presenter.game
    }

    func gameInfoCellDidTapOnMap(_ cell: GameInfoCell) {
        presenter.didTapOnMap()
    }
}

// MARK: - Game Description

extension GameOrderVC: GameDescriptionDelegate {
    func optionalDescription(for descriptionCell: GameGeneralDescriptionCell) -> String? {
        return presenter.game.optionalDescription
    }
}

// MARK: - Register

extension GameOrderVC: GameRegisterCellDelegate {
    func selectedNumberOfPeople(in registerCell: GameRegisterCell) -> Int {
        return presenter.numberOfPeople
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangeNumberOfPeopleInTeam number: Int) {
        presenter.didChangeNumberOfPeople(number)
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangeTeamName newName: String) {
        presenter.didChangeTeamName(newName)
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangeCaptainName newName: String) {
        presenter.didChangeCaptainName(newName)
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangeEmail email: String) {
        presenter.didChangeEmail(email)
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangePhone extractedNumber: String, didCompleteMask: Bool) {
        presenter.isPhoneNumberValid = didCompleteMask
        presenter.didChangePhone(extractedNumber)
    }

    func registerCell(_ registerCell: GameRegisterCell, didChangeFeedback newValue: String) {
        presenter.didChangeComment(newValue)
    }
}

// MARK: - Certificate

extension GameOrderVC: GameCertificateCellDelegate {
    func titleForCell(_ certificateCell: GameCertificateCell) -> String {
        if certificateCell.associatedItemKind == .certificate {
            certificateCell.fieldView.title = "Введите номер сертификата/промокода"
            return "У вас есть промокод / сертификат Квиз, плиз! ?"
        }
        certificateCell.fieldView.title = "Введите промокод"
        return "У вас есть промокод?"
    }

    func accessoryText(for certificateCell: GameCertificateCell) -> String {
        // "Для активации сертификатов от наших партнеров свяжитесь с нами"
        return ""
    }

    func certificateCell(_ certificateCell: GameCertificateCell, didChangeCertificateCode newCode: String) {
        guard let index = indexForPresenter(of: certificateCell) else { return }
        presenter.didChangeSpecialCondition(newValue: newCode, at: index)

        updateUiOnCertificateTextChange(newCode: newCode)
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

// MARK: - Add Extra Certificate

extension GameOrderVC: GameAddExtraCertificateCellDelegate {
    func cellDidPressAddButton(_ cell: GameAddExtraCertificateCell) {
        presenter.didPressAddSpecialCondition()
    }
}

// MARK: - First Play

extension GameOrderVC: GameFirstPlayCellDelegate {
    func firstPlayCell(_ cell: GameFirstPlayCell, didChangeStateTo isFirstPlay: Bool) {
        hapticGenerator.impactOccurred()
        presenter.isFirstTimePlaying = isFirstPlay
    }
}

// MARK: - Payment Type

extension GameOrderVC: GamePaymentTypeCellDelegate {
    func availablePaymentTypes(in cell: GamePaymentTypeCell) -> [PaymentType] {
        return presenter.availablePaymentTypes
    }

    func isOnlinePaymentInitially(in cell: GamePaymentTypeCell) -> Bool {
        return presenter.isOnlinePaymentDefault
    }

    func paymentTypeCell(_ cell: GamePaymentTypeCell, didChangePaymentType isOnlinePayment: Bool) {
        hapticGenerator.impactOccurred()
        presenter.didChangeSelectedPaymentType(isOnlinePayment: isOnlinePayment)
    }
}

// MARK: - Online Payment

extension GameOrderVC: GameOnlinePaymentCellDelegate {
    func shouldDisplayCountPicker(in cell: GameOnlinePaymentCell) -> Bool {
        return !presenter.game.isOnlineGame
    }

    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.numberOfPaidPeople ?? presenter.numberOfPeople
    }

    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int {
        return presenter.numberOfPeople
    }

    func sumToPay(in cell: GameOnlinePaymentCell, forUpdatedNumberOfPeople number: Int) -> Double {
        return presenter.countSumToPay(forPeople: number)
    }

    func priceTextColor(in cell: GameOnlinePaymentCell) -> UIColor? {
        presenter.getPriceTextColor()
    }
}

// MARK: - Submit Button

extension GameOrderVC: GameSubmitButtonCellDelegate {
    func titleForButton(in cell: GameSubmitButtonCell) -> String? {
        presenter.getSubmitButtonTitle()
    }

    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton) {
        presenter.didPressSubmitButton()
    }

    func didPressTermsOfUse(in cell: GameSubmitButtonCell) {
        presenter.didPressTermsOfUse()
    }
}
