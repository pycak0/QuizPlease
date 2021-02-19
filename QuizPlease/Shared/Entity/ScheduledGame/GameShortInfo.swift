//
//  GameShortInfo.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

///Server response has a bunch of information given with the list of games but the field names are different from `GameInfo` model, so we store only game id here.
struct GameShortInfo: Decodable {
    var id: Int
    
    private var datetime: String
}

extension GameShortInfo {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy hh:mm"
        formatter.locale = Locale(identifier: "ru")
        formatter.calendar = .current
        formatter.timeZone = .current
        
        return formatter.date(from: datetime)
    }
}
