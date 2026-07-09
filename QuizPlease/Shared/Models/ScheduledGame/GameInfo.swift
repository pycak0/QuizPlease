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

private let gameNumberPrefix = "#"
private let defaultCurrencySymbol = "₽"
private let rubleCurrencyMarkers = ["₽", "руб.", "руб", "р."]

struct GameInfo: Decodable {
    static let placeholderValue = "-"
    static let defaultMaxParticipants = 9

    var id: String!
    var date: Date?

    private var numberGame: String?
    var nameGame: String = placeholderValue

    /// Date of the game
    var blockData: String = placeholderValue

    /// Background Image path on server
    private var special_mobile_banner: String?

    /// Background image for cell in Schedule
    var imageData: String?

    var time: String = placeholderValue

    /// Game annotation
    var gameDescription: String {
        description ?? Self.placeholderValue
    }
    private var description: String?

    private var text_block: String?

    /// See `GameStatus` for description
    private var status: Int?
    /// Special marketing flag "few places left!!"
    private var is_little_place: Bool?

    private var price: String = placeholderValue
    private var currency_symbol: String?
    /// Describing price e.g. "с человека". Use `priceDetails` instead of this
    private var text: String = ""

    private var place: String = placeholderValue
    private var address: String? = placeholderValue
    private var cityName: String = ""
    private var payment_icon: Int = 0
    /// Online game = 1; offline game = 0
    private var game_type: Int = 0
    private var price_type: Int = 0

    private var latitude: Double?
    private var longitude: Double?

    private var tables: [GameTable]?

    private var sdk_key: String?
    private var sdk_shop_id: String?

    /// Vacant places
    private var blockOf: Int = 0
    private var max_participants: Int?

    /// Custom registration fields on Game page
    private var custom_fields: [CustomFieldData]?
    /// Show remind button or not
    private var show_remind_button: Bool?

    private var is_show_promo_field: Bool?

    init() { }

    init(shortInfo: GameShortInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
        max_participants = shortInfo.max_participants
        currency_symbol = shortInfo.currency_symbol
    }

    mutating func setShortInfo(_ shortInfo: GameShortInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
        if let maxParticipants = shortInfo.max_participants {
            max_participants = maxParticipants
        }
        if let currencySymbol = shortInfo.currency_symbol {
            currency_symbol = currencySymbol
        }
    }

    mutating func setShortInfo(_ shortInfo: GameInfo) {
        id = shortInfo.id
        date = shortInfo.date
        special_mobile_banner = shortInfo.special_mobile_banner
        is_little_place = shortInfo.is_little_place
        show_remind_button = shortInfo.show_remind_button
        if let maxParticipants = shortInfo.max_participants {
            max_participants = maxParticipants
        }
        if let currencySymbol = shortInfo.currency_symbol {
            currency_symbol = currencySymbol
        }
    }
}

extension GameInfo {
    var currencySymbol: String {
        let symbol = currency_symbol?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return symbol.isEmpty ? defaultCurrencySymbol : symbol
    }

    var priceNumber: Int? {
        return Int(price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted))
    }

    var placeInfo: Place {
        return Place(
            name: place,
            cityName: cityName,
            address: address ?? "",
            latitude: latitude ?? 0,
            longitude: longitude ?? 0
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
        return "\(priceWithCurrency) \(details)"
    }

    var priceWithCurrency: String {
        let trimmedPrice = price.trimmingCharacters(in: .whitespacesAndNewlines)
        guard priceNumber != nil else {
            return trimmedPrice
        }

        let priceWithoutCurrency = rubleCurrencyMarkers.reduce(trimmedPrice) { result, marker in
            result.removingCurrencyMarker(marker)
        }
        return "\(priceWithoutCurrency) \(currencySymbol)"
    }

    var gameNumber: String {
        let number = numberGame ?? gameNumberPrefix
        if number.trimmingCharacters(in: .whitespaces).hasPrefix(gameNumberPrefix) {
            return number
        }
        return gameNumberPrefix + number
    }

    /// A title of game containing its `nameGame` and `gameNumber` properties separated by a whitespace
    var fullTitle: String {
        return "\(nameGame.trimmingCharacters(in: .whitespaces)) \(gameNumber)"
    }

    var paymentOption: PaymentOption {
        PaymentOption(rawValue: payment_icon) ?? .cashOnly
    }

    var availablePaymentTypes: [PaymentType] {
        switch paymentOption {
        case .cashOnly, .creditCardOffline, .cashOrCreditOffline, .onlineCustom, .freeEnter:
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

    var priceKind: PriceKind {
        return PriceKind(rawValue: price_type) ?? PriceKind.person
    }

    var gameTables: [GameTable] {
        return tables ?? []
    }

    /// Status of the game
    var gameStatus: GameStatus? {
        let realStatus = GameStatus(rawValue: self.status ?? -999)
        let isFewPlacesFlagEnabled = is_little_place ?? false
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

    var maxParticipants: Int {
        guard let maxParticipants = max_participants, maxParticipants > 0 else {
            return Self.defaultMaxParticipants
        }
        return maxParticipants
    }

    var customFields: [CustomFieldData]? {
        custom_fields
    }

    var showRemindButton: Bool {
        show_remind_button ?? false
    }

    var showPromoFields: Bool {
        is_show_promo_field ?? false
    }
}

private extension String {

    func removingCurrencyMarker(_ marker: String) -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasSuffix(marker) else { return trimmed }
        let endIndex = trimmed.index(trimmed.endIndex, offsetBy: -marker.count)
        return String(trimmed[..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
