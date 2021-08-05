//
//  SecurityHelper.swift
//  QuizPlease
//
//  Created by Владислав on 25.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

fileprivate protocol SecurityKey {
    var key: String { get }
}

enum KeyKind {
    enum PaymentKeyKind: SecurityKey {
        case dev, prod
        
        var key: String {
            switch self {
            case .dev: return "devKey"
            case .prod: return "productionKey"
            }
        }
    }
    
    case paymentKey(PaymentKeyKind)
}

fileprivate struct KeyStore: Decodable {
    let paymentKeys: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case paymentKeys = "PaymentKeys"
    }
}

class SecurityHelper {
    private let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    private let keyStore: KeyStore
    
    static let shared = SecurityHelper()
    
    private init() {
        guard
            let path = keysPath,
            let data = FileManager.default.contents(atPath: path)
        else {
            keyStore = KeyStore(paymentKeys: [:])
            print("❌🔒[\(Self.self).swift] Error initializing key store: no data found for given path.")
            return
        }
        do {
            let plist = try PropertyListDecoder().decode(KeyStore.self, from: data)
            keyStore = plist
        } catch {
            keyStore = KeyStore(paymentKeys: [:])
            print("❌🔒[\(Self.self).swift] Error decoding key store: \(error.localizedDescription)")
        }
    }
    
    func value(for keyType: KeyKind) -> String? {
        switch keyType {
        case let .paymentKey(kind):
            return getPaymentKey(kind)
        }
    }
    
    private func getPaymentKey(_ kind: KeyKind.PaymentKeyKind) -> String? {
        let keys = keyStore.paymentKeys
        if keys.isEmpty {
            print("⚠️🔒[\(Self.self).swift] Warning: payment keys dictionary is empty.")
        }
        return keys[kind.key]
    }
}
