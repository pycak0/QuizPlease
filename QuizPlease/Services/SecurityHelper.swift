//
//  SecurityHelper.swift
//  QuizPlease
//
//  Created by Владислав on 25.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

protocol KeyProvider {
    func value(for key: KeyKind) -> Any?
    func string(for key: KeyKind) -> String?
}

fileprivate protocol SecurityKey {
    var key: String { get }
}

enum KeyKind {
    enum PaymentKeyKind: SecurityKey {
        /// Development payment info key
        case dev
        /// Default production payment info key
        case prod
        /// Payment info key for given  city
        case forCity(id: Int)
        
        var key: String {
            switch self {
            case .dev: return "devKey"
            case .prod: return "productionKey"
            case let .forCity(id): return "\(id)"
            }
        }
    }
    
    case paymentKey(PaymentKeyKind)
}

fileprivate struct KeyStore: Decodable {
    let shopKeys: [String: PaymentInfo]
    
    private enum CodingKeys: String, CodingKey {
        case shopKeys = "ShopKeys"
    }
}

struct PaymentInfo: Decodable {
    let paymentKey: String
    let shopId: String?
}

class SecurityHelper: KeyProvider {
    private let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    private let keyStore: KeyStore
    
    static let shared = SecurityHelper()
    
    private init() {
        guard
            let path = keysPath,
            let data = FileManager.default.contents(atPath: path)
        else {
            keyStore = KeyStore(shopKeys: [:])
            print("❌🔒[\(Self.self).swift] Error initializing key store: no data found for given path.")
            return
        }
        do {
            let plist = try PropertyListDecoder().decode(KeyStore.self, from: data)
            keyStore = plist
        } catch {
            keyStore = KeyStore(shopKeys: [:])
            print("❌🔒[\(Self.self).swift] Error decoding key store: \(error.localizedDescription)")
        }
    }
    
    func value(for keyType: KeyKind) -> Any? {
        switch keyType {
        case let .paymentKey(kind):
            return getPaymentKey(kind)
        }
    }
    
    func string(for key: KeyKind) -> String? {
        switch key {
        case .paymentKey:
            print("⚠️🔒[\(Self.self).swift] Warning: '\(key)' KeyKind does not contain String data.")
            return nil
        }
    }
    
    private func getPaymentKey(_ kind: KeyKind.PaymentKeyKind) -> PaymentInfo? {
        let keys = keyStore.shopKeys
        if keys.isEmpty {
            print("⚠️🔒[\(Self.self).swift] Warning: payment keys dictionary is empty.")
        }
        return keys[kind.key]
    }
}
