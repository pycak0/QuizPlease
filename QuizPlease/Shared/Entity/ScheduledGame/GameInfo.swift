//
//MARK:  GameInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameInfo: Decodable {
    static let placeholderValue = "-"
    
    var id: Int!
    var date: Date?
    
    private var numberGame: String = "#"
    var nameGame: String = placeholderValue
    
    ///Date of the game
    var blockData: String = placeholderValue
    
    ///Background Image path on server
    var mobile_banner: String?
    
    ///background image for cell in Schedule
    var imageData: String?
    
    var time: String = placeholderValue
    var description: String = placeholderValue
    
    private var status: Int?

    private var price: String = placeholderValue
    ///Describing price e.g. "с человека". Use `priceDetails` instead of this
    private var text: String = ""
    
    private var place: String = placeholderValue
    private var address: String = placeholderValue
    private var cityName: String = ""
    private var payment_icon: Int = 0
    private var game_type: Int = 0
    
    init(id: Int, date: Date?) {
        self.id = id
        self.date = date
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
        if numberGame.trimmingCharacters(in: .whitespaces).hasPrefix("#") {
            return numberGame
        }
        return "#" + numberGame
    }
    
    ///A title of game containing its `nameGame` and `gameNumber` properties separated by a whitespace
    var fullTitle: String {
        return "\(nameGame.trimmingCharacters(in: .whitespaces)) \(gameNumber)"
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
    
    var isOnlineGame: Bool {
        return game_type == 1
    }
    
    var gameStatus: GameStatus? {
        return GameStatus(rawValue: status ?? -999)
    }
    
    ///Calculates the day of week from game's Date and appends it to the `blockData`
    var formattedDate: String {
        guard let date = date else { return blockData }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru")
        
        let weekDay = Calendar.current.component(.weekday, from: date)
        let week = formatter.weekdaySymbols[weekDay-1]
        
        let dateString = "\(formatter.string(from: date)), \(week)"
        return dateString
    }
}
