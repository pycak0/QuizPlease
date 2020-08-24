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
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}

extension GameOrderVC: GameInfoCellDelegate {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo {
        return presenter.game
    }
}


extension GameOrderVC: GameDescriptionDelegate {}

extension GameOrderVC: GamePayCellDelegate {
    func sumToPay(in gamePayCell: GamePayCell, forNumberOfPeople number: Int) -> Decimal {
        //presenter. ...
        return presenter.game.price * Decimal(number)
    }
    
    func gamePayCell(_ gamePayCell: GamePayCell, didChangeNumberOfPeopleToPay number: Int) {
        //
    }
    
    func gamePayCell(_ gamePayCell: GamePayCell, didChangePaymentMethod isApplePay: Bool) {
        //guard let indexPath = tableView.indexPath(for: gamePayCell) else { return }
//        UIView.animate(withDuration: 0.1) {
//            gamePayCell.frame.setHeight(isApplePay ? 444 : 290)
//        }

    }
    
}
