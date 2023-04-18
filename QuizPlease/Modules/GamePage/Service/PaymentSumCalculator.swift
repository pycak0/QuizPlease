//
//  PaymentSumCalculator.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that calculates payment sum for the game
protocol PaymentSumCalculator {

    /// Calculates final sum to pay for the game with given parameters.
    /// - Parameters:
    ///   - number: Number of people to pay for
    ///   - gamePrice: Base price of the game for the 1 person or the whole team (depending on the game type)
    ///   - isOnlineGame: For online games, `gamePrice` parameter is indicating the price for the whole team.
    ///   For other games, `gamePrice` shows the price for each person.
    ///   - discounts: An arary of all discounts applied to the game.
    /// - Returns: Total amount due
    func calculateSumToPay(
        forPeople number: Int,
        gamePrice: Int,
        isOnlineGame: Bool,
        discounts: [SpecialCondition.DiscountInfo]
    ) -> Double
}

/// Service that calculates payment sum for the game
final class PaymentSumCalculatorImpl: PaymentSumCalculator {

    // MARK: - PaymentSumCalculator

    func calculateSumToPay(
        forPeople number: Int,
        gamePrice: Int,
        isOnlineGame: Bool,
        discounts: [SpecialCondition.DiscountInfo]
    ) -> Double {
        var price = Double(gamePrice)
        var peopleToPay = Double(number)

        let (peopleFree, percentFraction) = countAllDiscounts(discounts)
        let peopleForFree = Double(peopleFree)

        if peopleForFree >= peopleToPay {
            return 0
        }
        peopleToPay -= peopleForFree

        if isOnlineGame {
            /// Процентный промокод работает только на онлайн-играх, а `price` на них считается за всю команду
            let percentDiscountSum = price * percentFraction
            price = max(price - percentDiscountSum, 0)
        } else {
            /// Разделение оплаты по количеству человек есть только на офлайн-играх
            price *= peopleToPay
        }

        return price
    }

    // MARK: - Private Methods

    private func countAllDiscounts(
        _ discounts: [SpecialCondition.DiscountInfo]
    ) -> (totalPeopleForFree: Int, totalPercentFraction: Double) {

        var percentFraction = 0.0
        var peopleForFree = 0
        for discountInfo in discounts {
            switch discountInfo.discount {
            case let .percent(fraction):
                percentFraction += fraction
            case let .somePeopleForFree(amount):
                if peopleForFree != Int.max {
                    peopleForFree += amount
                }
            case let .certificateDiscount(type):
                switch type {
                case .allTeamFree:
                    peopleForFree = Int.max
                case let .numberOfPeopleForFree(amount):
                    if peopleForFree != Int.max {
                        peopleForFree += amount
                    }
                case .none:
                    continue
                }
            case .none:
                continue
            }
        }

        return (peopleForFree, percentFraction)
    }
}
