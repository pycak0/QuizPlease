//
// MARK: GameInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

private let translationDict: [String: String] = [
    "оплата на сайте и в баре": "оплата онлайн или в баре",
    "оплата онлайн (через Яндекс кассу)": "оплата онлайн",
    "наличные (оплата на месте)": "наличные",
    "наличные или карта (оплата на месте)": "наличные или карта",
    "карта (оплата на месте)": "карта",
    "онлайн через смс": "онлайн"
]

struct GameInfo: Decodable {
    static let placeholderValue = "-"

    var id: Int!
    var date: Date?

    private var numberGame: String = "#"
    var nameGame: String = placeholderValue

    /// Date of the game
    var blockData: String = placeholderValue

    /// Background Image path on server
    private var special_mobile_banner: String?

    /// Background image for cell in Schedule
    var imageData: String?

    var time: String = placeholderValue
    /// Game annotation
    var description: String = placeholderValue

    private var text_block: String?

    /// See `GameStatus` for description
    private var status: Int?
    /// Special marketing flag "few places left!!"
    private var is_little_place: Int?

    private var price: String = placeholderValue
    /// Describing price e.g. "с человека". Use `priceDetails` instead of this
    private var text: String = ""

    private var place: String = placeholderValue
    private var address: String? = placeholderValue
    private var cityName: String = ""
    private var payment_icon: Int = 0
    /// Online game = 1; offline game = 0
    private var game_type: Int = 0

    private var latitude: String?
    private var longitude: String?

    private var sdk_key: String?
    private var sdk_shop_id: String?

    /// Vacant places
    private var blockOf: Int = 0

    /// Custom registration fields on Game page
    private var custom_fields: [CustomFieldData]?
    /// Show remind button or not
    private var show_remind_button: Bool?

    init() { }

    init(shortInfo: GameShortInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
    }

    mutating func setShortInfo(_ shortInfo: GameShortInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
    }

    mutating func setShortInfo(_ shortInfo: GameInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
    }
}

extension GameInfo {
    var priceNumber: Int? {
        return Int(price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted))
    }

    var placeInfo: Place {
        let latitude = Double(self.latitude ?? "") ?? 0
        let longitude = Double(self.longitude ?? "") ?? 0
        return Place(
            name: place,
            cityName: cityName,
            address: address ?? "",
            latitude: latitude,
            longitude: longitude
        )
    }

    var priceDetails: String {
        let components = text.components(separatedBy: ", ")
        var details = components.first.map { "\($0), " } ?? ""
        var text = ""
        if components.count >= 2 {
            text = components[1]
        }
        details += translationDict[text] ?? text
        return "\(price) \(details)"
    }

    var gameNumber: String {
        if numberGame.trimmingCharacters(in: .whitespaces).hasPrefix("#") {
            return numberGame
        }
        return "#" + numberGame
    }

    /// A title of game containing its `nameGame` and `gameNumber` properties separated by a whitespace
    var fullTitle: String {
        return "\(nameGame.trimmingCharacters(in: .whitespaces)) \(gameNumber)"
    }

    var availablePaymentTypes: [PaymentType] {
        switch PaymentOption(rawValue: payment_icon) {
        case .none, .cashOnly, .creditCardOffline, .cashOrCreditOffline, .onlineCustom:
            return [.cash]
        case .onlineInApp:
            return [.online]
        case .cashOrOnlineInApp:
            return [.cash, .online]
        }
    }

    var isOnlineGame: Bool {
        return game_type == 1
    }

    /// Status of the game
    var gameStatus: GameStatus? {
        let realStatus = GameStatus(rawValue: self.status ?? -999)
        let isFewPlacesFlagEnabled = ((is_little_place ?? 0) == 1)
        let displayStatus = (isFewPlacesFlagEnabled && realStatus == .placesAvailable)
            ? .fewPlaces
            : realStatus
        return displayStatus
    }

    /// Path of backgorund image in the header of game detail page
    var backgroundImagePath: String? {
        get { special_mobile_banner }
        set { special_mobile_banner = newValue }
    }

    /// Calculates the day of week from game's Date and appends it to the `blockData`
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

    var optionalDescription: String? {
        text_block
    }

    var paymentKey: String? {
        sdk_key
    }

    var shopId: String? {
        if let id = sdk_shop_id, !id.isEmpty {
            return id
        }
        return nil
    }

    var vacantPlaces: Int {
        blockOf
    }

    var customFields: [CustomFieldData]? {
        custom_fields
    }

    var showRemindButton: Bool {
        show_remind_button ?? false
    }
}
