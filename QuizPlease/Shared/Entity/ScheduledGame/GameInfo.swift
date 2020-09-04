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
    var numberGame: String = "#"
    var nameGame: String = "-"
    
    ///Date of the game
    var blockData: String = "-"
    
    private var place: String = "-"
    private var address: String = "-"
    
    var time: String = "-"
    
    private var price: String = "-"
    ///Describing price e.g. "с человека". Use `priceDetails` instead of this
    private var text: String = ""
    
    var description: String = "-"
    
    var cityName: String = ""
    
    init(id: Int) {
        self.id = id
    }
}

extension GameInfo {
    var priceNumber: Int? {
        return Int(price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted))
    }
    
    var placeInfo: Place {
        Place(name: place, address: address)
    }
    
    var priceDetails: String {
        "\(price) \(text)"
    }
}
