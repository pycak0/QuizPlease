//
//MARK:  GameInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameInfo: Decodable {
    var id: Int!
    private var numberGame: String = "#"
    var nameGame: String = "-"
    
    ///Date of the game
    var blockData: String = "-"
    
    var time: String = "-"
    var description: String = "-"
    
    var status: GameStatus?

    private var price: String = "-"
    ///Describing price e.g. "с человека". Use `priceDetails` instead of this
    private var text: String = ""
    
    private var place: String = "-"
    private var address: String = "-"
    private var cityName: String = ""
    private var payment_icon: Int = 0
    
    init(id: Int) {
        self.id = id
    }
}

extension GameInfo {
    var priceNumber: Int? {
        return Int(price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted))
    }
    
    var placeInfo: Place {
        return Place(name: place, cityName: cityName, address: address)
    }
    
    var priceDetails: String {
        "\(price) \(text)"
    }
    
    var gameNumber: String {
        if numberGame.hasPrefix("#") {
            return numberGame
        }
        return "#" + numberGame
    }
    
    var availablePaymentTypes: [PaymentType] {
        switch payment_icon {
        case 0:
            return [.cash]
        case 1, 3:
            return [.online]
        case 2, 5:
            return [.cash, .online]
        default:
            return [.cash]
        }
    }
}
